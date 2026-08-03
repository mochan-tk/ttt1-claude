Closes #<!-- Task issue number (required — AGENTS.md, unit of work) -->

Plan: <!-- link to the plan comment on the Task issue (plan of record —
session-orchestration skill; plan text auto-written here is a copy) -->

## Summary

<!-- 2–4 sentences: what changed and why, in terms of the Task's Objective. -->

## Evidence

<!-- One row per acceptance criterion of the Task issue. "pass (untested)" is
     not a result; "deferred" requires a linked follow-up issue
     (.claude/skills/verification/SKILL.md). -->

| Criterion | Evidence (command / link) | Result |
|---|---|---|
|  |  |  |

## Deviations

<!-- Anything that differs from the Task brief, and why. Silent deviations are
     the most expensive class of agent error — "None" must be literally true. -->

None.

## Follow-ups

<!-- Suggested downstream issue changes (feeds the replanning procedure), or
     "None". Scaffold friction observed? File or +1 a retro:candidate issue
     (retro skill, Candidate ledger). -->

None.

## Upstream

<!-- Exactly one line, required (SCAFFOLD-CHANGELOG.md, Upstreaming):
     `upstream: proposed <template-PR-URL>` when the change is
     project-agnostic and was proposed on the template, or
     `upstream: not-applicable — <reason>` otherwise. -->

upstream: not-applicable — <reason>

## Checklist

- [ ] Plan was posted as a Task-issue comment before implementation and is
      linked above (the plan comment predates the first commit).
- [ ] No acceptance criterion is `deferred` without a linked follow-up
      issue; none remains deferred on a "completed" claim.
- [ ] Diff stays inside the issue's **File ownership** paths (single-writer rule).
- [ ] Every command in the issue's **Verification** section was run; output captured above.
- [ ] No test, lint rule, or CI check was deleted, skipped, or weakened.
- [ ] Record-before-report comment posted on the Task issue.
- [ ] All persistent artifacts in this PR are English-only.
