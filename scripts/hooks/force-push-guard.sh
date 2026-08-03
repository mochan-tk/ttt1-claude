#!/usr/bin/env bash
# force-push-guard.sh — PreToolUse hook closing the force-push path in all
# its spellings. The settings.json deny rules catch the common prefixes;
# this hook catches reordered flags (`git push origin --force`,
# `git push -f origin main`) and refspec force (`git push origin +main`),
# which prefix-based permission rules cannot express (ADR-0001,
# hooks-as-enforcement).
#
# Input: PreToolUse hook JSON on stdin (tool_input.command for Bash).
# Exit 0 = allow, exit 2 = block with the stderr message surfaced.

set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0  # never hard-block on a missing tool

CMD="$(jq -r '.tool_input.command // empty' 2>/dev/null || true)"
[ -n "$CMD" ] || exit 0

case "$CMD" in
  *"git push"*) ;;
  *) exit 0 ;;
esac

if printf '%s' "$CMD" | grep -qE -- '--force(-with-lease)?\b|(^| )-f( |$)|git push[^|;&]* \+[^ ]'; then
  echo "force-push-guard: force pushes are closed in this scaffold" \
    "(history is the audit trail — AGENTS.md §1). If a rewrite is truly" \
    "needed, a human runs it outside the agent path and records why." >&2
  exit 2
fi
exit 0
