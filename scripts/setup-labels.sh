#!/usr/bin/env bash
# setup-labels.sh — create/refresh the canonical label set this scaffold
# relies on (plan-management, task-routing, session-orchestration skills).
# Idempotent: uses `gh label create --force`.
#
# Usage: setup-labels.sh [-R owner/repo] [--dry-run]
#   --dry-run  Print the labels that would be ensured; no GitHub call.

set -euo pipefail

REPO_ARGS=()
DRY_RUN=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -R) [[ -n "${2:-}" ]] || { echo "error: -R requires owner/repo" >&2; exit 2; }
        REPO_ARGS=(--repo "$2"); shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done
$DRY_RUN || command -v gh >/dev/null 2>&1 || { echo "error: gh CLI not found" >&2; exit 1; }

# ${arr[@]+"${arr[@]}"} guards the empty-array expansion, which is an unbound
# variable under `set -u` on bash 3.2 (macOS /bin/bash); fixed in bash 4.4.
create() {
  if $DRY_RUN; then
    printf 'dry-run: would ensure %-16s #%s  %s\n' "$1" "$2" "$3"
  else
    gh label create "$1" ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --color "$2" --description "$3" --force
  fi
}

create "type:epic"    "5319E7" "Outline item; parent of Task sub-issues (plan-management)"
create "type:task"    "0E8A16" "Self-contained work order for one agent session"
create "ai:ready"     "1D76DB" "Brief meets the planner quality bar; dispatchable when unblocked"
create "needs:human"  "B60205" "Escalation: judgment/trust decision required (AGENTS.md, Ambiguity rule)"
create "needs:replan" "D93F0B" "Escalation: plan/scope must change before work continues"
create "exec:cloud"   "C2E0C6" "Route: Claude Code web/cloud session — async, parallel, draft PR"
create "exec:app"     "BFDADC" "Route: Claude Code desktop app / orchestrator session — steerable, worktree-isolated"
create "exec:cli"     "FEF2C0" "Route: Claude Code CLI — scripted / batch / CI-triggered"
create "exec:ide"     "F9D0C4" "Route: Claude Code IDE extension, human in the loop — ambiguous or hardware work"
create "retro:candidate" "EDEDED" "Observed scaffold friction; promote to a retro: PR at the 2nd occurrence"
create "risk:high"    "CB2431" "Exception gate: plan comment needs an approval comment before execution (session-orchestration)"

echo "Done. 11 labels ensured."
