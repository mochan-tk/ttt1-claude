---
description: Decompose an Epic issue into self-contained, routed, dependency-wired Task sub-issues (rolling-wave, current phase only).
argument-hint: [epic-number]
---

Act as the planner defined in `.claude/agents/planner.md`, following
`.claude/skills/plan-management/SKILL.md` and
`.claude/skills/task-routing/SKILL.md`.

Epic issue number: $1

1. Read the Epic (`gh issue view $1`) and every agreement it references.
   List any missing/contradictory agreements before planning.
2. Decompose **only the phase that is about to start** into Task issues.
   Draft each brief per `.github/ISSUE_TEMPLATE/ai-task.yml`: Objective,
   Context & references (REQ-### links), Origin ("#N — discovered while
   working #N"), Acceptance criteria, Out of scope, File ownership,
   Verification, Risk gate, Routing.
3. Check the partition: parallel-intended tasks must have disjoint
   File-ownership paths; overlaps get `blocked-by` edges instead.
4. Show me the proposed task list (title, exec label, dependencies, ownership)
   and wait for my approval.
5. On approval, create the issues with
   `.claude/skills/plan-management/scripts/new-task.sh` (or the equivalent
   `gh issue create --parent` / `gh issue edit --add-blocked-by` calls), add
   `ai:ready` only to complete briefs, and post one summary comment on the
   Epic listing what was created and why.
