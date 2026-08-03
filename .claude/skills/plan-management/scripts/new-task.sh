#!/usr/bin/env bash
# new-task.sh — create a Task issue wired into the plan graph in one step.
#
# Usage:
#   new-task.sh (--dry-run | --apply) -t "Title" -b body.md -p <epic-number> \
#               -e <cloud|app|cli|ide> [-d "14,15"] [--origin "#N — context"] \
#               [--risk normal|high] [-R owner/repo] [--ready]
#
#   --dry-run    Print exactly what would be created (title, labels, wiring,
#                body) and exit without touching GitHub.
#   --apply      Actually create the issue. Exactly one of --dry-run/--apply
#                is required — this flag is the live-GitHub boundary, so a
#                rehearsal can never create a live issue by accident.
#   -t  Task title (required)
#   -b  Path to a body file following .github/ISSUE_TEMPLATE/ai-task.yml
#       sections (required; start from ../templates/task-body.md)
#   -p  Parent Epic issue number (required)
#   -e  Execution surface -> adds label exec:<value> (required)
#   -d  Comma-separated issue numbers this task is blocked by (optional)
#   --origin  One-line origin citation ("#N — discovered while working #N");
#             substituted into the body's Origin placeholder line
#   --risk    normal (default) or high. high adds the risk:high label and
#             marks the body's Risk gate line (plan-comment approval gate)
#   -R  Target repository (optional; defaults to current repo)
#   --ready  Also add the ai:ready label (only when the brief is complete)
#
# --apply preflight — all must pass before any creation call, so an input
# error can never leave a half-wired issue in the graph:
#   1. gh supports --parent/--blocked-by (gh >= 2.94)
#   2. the parent issue exists and carries the type:epic label
#   3. every blocker in -d, and the --origin issue, are readable
#   4. every label the call would apply already exists in the repository

set -euo pipefail

MODE="" TITLE="" BODY="" PARENT="" EXEC="" DEPS="" ORIGIN="" RISK="normal"
READY=false
REPO_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) [[ -z "$MODE" ]] || { echo "error: give exactly one of --dry-run/--apply" >&2; exit 2; }
               MODE="dry-run"; shift ;;
    --apply)   [[ -z "$MODE" ]] || { echo "error: give exactly one of --dry-run/--apply" >&2; exit 2; }
               MODE="apply"; shift ;;
    -t) TITLE="$2"; shift 2 ;;
    -b) BODY="$2"; shift 2 ;;
    -p) PARENT="$2"; shift 2 ;;
    -e) EXEC="$2"; shift 2 ;;
    -d) DEPS="$2"; shift 2 ;;
    --origin) ORIGIN="$2"; shift 2 ;;
    --risk) RISK="$2"; shift 2 ;;
    -R) REPO_ARGS=(--repo "$2"); shift 2 ;;
    --ready) READY=true; shift ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

[[ -n "$MODE" ]] || {
  echo "error: exactly one of --dry-run or --apply is required" >&2
  echo "(--dry-run rehearses; --apply is the live-GitHub boundary)" >&2; exit 2; }
[[ -n "$TITLE" && -n "$BODY" && -n "$PARENT" && -n "$EXEC" ]] || {
  echo "error: -t, -b, -p and -e are required (see --help)" >&2; exit 2; }
[[ -f "$BODY" ]] || { echo "error: body file not found: $BODY" >&2; exit 2; }
case "$EXEC" in cloud|app|cli|ide) ;; *)
  echo "error: -e must be one of: cloud, app, cli, ide" >&2; exit 2 ;; esac
case "$RISK" in normal|high) ;; *)
  echo "error: --risk must be normal or high" >&2; exit 2 ;; esac
command -v gh >/dev/null 2>&1 || { echo "error: gh CLI not found" >&2; exit 1; }

LABELS="type:task,exec:${EXEC}"
$READY && LABELS+=",ai:ready"
[[ "$RISK" == "high" ]] && LABELS+=",risk:high"

# Substitute --origin / --risk into the canonical placeholder lines. The
# substitution is fail-closed: a customized body without the placeholder
# rejects the flag instead of silently dropping the information.
BODY_CONTENT="$(cat "$BODY")"
ORIGIN_PLACEHOLDER='- <!-- "#N — discovered while working #N" (or pass --origin to new-task.sh) -->'
RISK_PLACEHOLDER='- normal <!-- or: risk:high — stops after the plan comment until a human approves that exact comment URL (or pass --risk high) -->'
if [[ -n "$ORIGIN" ]]; then
  case "$BODY_CONTENT" in
    *"$ORIGIN_PLACEHOLDER"*)
      BODY_CONTENT="${BODY_CONTENT/"$ORIGIN_PLACEHOLDER"/- $ORIGIN}" ;;
    *) echo "error: --origin given but the body has no Origin placeholder line — edit the body directly" >&2
       exit 2 ;;
  esac
fi
if [[ "$RISK" == "high" ]]; then
  case "$BODY_CONTENT" in
    *"$RISK_PLACEHOLDER"*)
      BODY_CONTENT="${BODY_CONTENT/"$RISK_PLACEHOLDER"/- risk:high — stops after the plan comment until a human approves that exact comment URL}" ;;
    *) echo "error: --risk high given but the body has no Risk gate placeholder line — edit the body directly" >&2
       exit 2 ;;
  esac
fi

if [[ "$MODE" == "dry-run" ]]; then
  echo "dry-run: no GitHub call made. Would create:"
  echo "  Title:      $TITLE"
  echo "  Labels:     $LABELS"
  echo "  Parent:     #$PARENT"
  [[ -n "$DEPS" ]] && echo "  Blocked by: $DEPS"
  [[ -n "$ORIGIN" ]] && echo "  Origin:     $ORIGIN"
  echo "  Risk:       $RISK"
  echo "---- body ----"
  printf '%s\n' "$BODY_CONTENT"
  exit 0
fi

# ---- LIVE GITHUB BOUNDARY (everything below can mutate the repository) ----

# Preflight 1: capability.
gh issue create --help 2>/dev/null | grep -q -- '--parent' || {
  echo "error: this gh version lacks --parent/--blocked-by (need >= 2.94)" >&2; exit 1; }

# Preflight 2: parent exists and is an Epic.
PARENT_LABELS="$(gh issue view "$PARENT" ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} \
  --json labels --jq '.labels[].name' 2>/dev/null)" || {
  echo "error: parent issue #$PARENT is not readable" >&2; exit 1; }
printf '%s\n' "$PARENT_LABELS" | grep -qx 'type:epic' || {
  echo "error: parent #$PARENT does not carry type:epic" >&2; exit 1; }

# Preflight 3: blockers and origin are readable.
check_readable() {
  gh issue view "$1" ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --json number >/dev/null 2>&1 \
    || { echo "error: issue #$1 (referenced by $2) is not readable" >&2; exit 1; }
}
if [[ -n "$DEPS" ]]; then
  for dep in $(printf '%s' "$DEPS" | tr ',' ' '); do check_readable "$dep" "-d"; done
fi
if [[ -n "$ORIGIN" ]]; then
  onum="$(printf '%s' "$ORIGIN" | grep -oE '#[0-9]+' | head -1 | tr -d '#' || true)"
  [[ -n "$onum" ]] && check_readable "$onum" "--origin"
fi

# Preflight 4: every label exists.
EXISTING_LABELS="$(gh label list ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --limit 100 \
  --json name --jq '.[].name')"
for lbl in $(printf '%s' "$LABELS" | tr ',' ' '); do
  printf '%s\n' "$EXISTING_LABELS" | grep -qx "$lbl" || {
    echo "error: label '$lbl' does not exist (run scripts/setup-labels.sh)" >&2; exit 1; }
done

# One creation call wires parent, labels, and dependencies atomically —
# a create-then-edit sequence could leak an unwired task into the frontier
# if the edit step failed.
CREATE_ARGS=(--title "$TITLE" --body "$BODY_CONTENT" \
  --label "$LABELS" --parent "$PARENT")
if [[ -n "$DEPS" ]]; then
  CREATE_ARGS+=(--blocked-by "$DEPS")
fi

# ${arr[@]+...} guards the empty-array expansion that aborts under `set -u`
# on macOS bash 3.2 (same idiom as scripts/tuning-status.sh).
URL=$(gh issue create ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} "${CREATE_ARGS[@]}")
NUM="${URL##*/}"
echo "Created task #${NUM} under epic #${PARENT}: ${URL}"

if [[ -n "$DEPS" ]]; then
  echo "Wired dependencies: #${NUM} blocked by ${DEPS}"
fi

echo "Next: verify the brief, then dispatch when it appears in frontier.sh output."
