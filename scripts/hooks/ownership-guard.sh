#!/usr/bin/env bash
# ownership-guard.sh — PreToolUse hook enforcing the single-writer rule
# (AGENTS.md §5) mechanically: file edits outside the current Task's
# File-ownership globs are blocked, not merely discouraged.
#
# Scope source: .claude/session-scope — one glob per line, written by the
# /start-task command from the Task issue's File ownership section, and
# gitignored (it is per-session state, never repository truth).
#
# Fail-open by design when NO scope file exists (sessions that are not
# working a Task issue — exploration, planning, onboarding — edit freely).
# Fail-closed once a scope is declared: a blocked edit exits 2, which
# Claude Code treats as "deny and surface the message".
#
# Input: PreToolUse hook JSON on stdin (tool_input.file_path).
# Dependencies: bash 3.2+, jq (same dependency as scripts/setup-ruleset.sh).

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCOPE_FILE="$ROOT/.claude/session-scope"

[ -f "$SCOPE_FILE" ] || exit 0

command -v jq >/dev/null 2>&1 || exit 0  # no jq: never hard-block on a missing tool

FILE_PATH="$(jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
[ -n "$FILE_PATH" ] || exit 0

# Normalize to a repo-relative path for glob matching.
case "$FILE_PATH" in
  "$ROOT"/*) REL="${FILE_PATH#"$ROOT"/}" ;;
  /*) exit 0 ;;  # outside the repository: not this guard's concern
  *) REL="$FILE_PATH" ;;
esac

# plan.md is the sanctioned per-session cache (session-orchestration skill).
[ "$REL" = "plan.md" ] && exit 0

while IFS= read -r glob; do
  [ -z "$glob" ] && continue
  case "$glob" in \#*) continue ;; esac
  # `**` means the whole tree; `dir/**` means everything under dir.
  if [ "$glob" = '**' ]; then exit 0; fi
  case "$glob" in
    *'/**') prefix="${glob%/\*\*}"
            case "$REL" in "$prefix"/*|"$prefix") exit 0 ;; esac ;;
    *)      # shellcheck disable=SC2254  # intentional glob match
            case "$REL" in $glob) exit 0 ;; esac ;;
  esac
done < "$SCOPE_FILE"

echo "ownership-guard: '$REL' is outside the Task's File-ownership scope" \
  "($SCOPE_FILE). Single-writer rule, AGENTS.md §5 — escalate with" \
  "needs:replan instead of widening the diff." >&2
exit 2
