---
description: Propagate a task outcome or deviation through the plan — keep/modify/split/add/close downstream issues, with rationale on the Epic.
argument-hint: [issue-number]
---

Act as the planner (`.claude/agents/planner.md`) executing the
Replanning procedure in `.claude/skills/plan-management/SKILL.md`.

Trigger issue number: $1

1. Read the recorded trigger (outcome comment / PR Deviations section) on
   #$1. If nothing is recorded, stop — the record must exist first
   (persistence rule).
2. Walk downstream: the issue's `Blocking:` list, the Epic's remaining
   sub-issues, and any task whose File ownership or references touch the
   changed area.
3. Propose a decision per affected issue — keep / modify / split / add /
   close-as-obsolete — with one-line reasons, and show me the full proposal
   before changing anything.
4. On approval: apply via `gh issue edit/create/close`, remove `ai:ready`
   from any task whose brief is now stale, clear `needs:replan` from the
   trigger, and post the rationale comment on the Epic (the plan's change
   log): added / modified / closed, and why.
