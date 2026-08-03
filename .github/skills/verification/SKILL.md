---
name: verification
description: Prove that work meets its Task issue — layered verification gates, the pre-PR checklist, the acceptance-criteria evidence table, and CI-failure triage. Use this before marking any PR ready for review, when writing the Verification section of a task brief, when a CI check fails, or when reviewing whether someone else's evidence actually proves their claim.
---

# Verification

Agent-produced work is verified in layers, cheapest and most deterministic
first. Each layer exists because the one after it is more expensive: a linter
catches in seconds what a human notices in minutes. The corollary that shapes
this whole repository: **automated checks are the ceiling on agent autonomy** —
work that only a human can verify can never be safely delegated, so investing
in layer 1 is investing in delegation itself.

## The layers

1. **Deterministic** — formatters, linters, type checks, unit/integration
   tests, build. Runs locally and in CI. Binary outcomes only.
2. **Security** — secret scanning, dependency review, code scanning. Never
   ship "temporary" suppressions without a linked issue.
3. **AI review** — Copilot code review and/or the `reviewer` agent, guided by
   `.github/instructions/code-review.instructions.md`. Catches claim/evidence
   gaps and silent deviations before a human spends attention.
4. **Human review** — judgment: is this the *right* change? Protected by
   branch ruleset (required PR + required checks + human approval on
   agent-authored PRs).

Never compensate for a lower layer at a higher one ("reviewer will catch it")
and never weaken a lower layer to pass ("delete the flaky test"). A failing
gate is information; removing the gate destroys the information.

## Test-first work orders

Acceptance criteria land as executable tests before implementation. The
work order carries its own finish line: "these checks turn green" is the
task's definition of done, fixed at dispatch time, and the pre-placed
checks join the required checks so the wall — not the agent's reading of
its own diff — judges completion. The wall judges; retries are budgeted:
the three-stage escalation (self-fix → parent session → human, advancing
on the same failure three times) is both the cap and the exit, so autonomy
stays bounded trial, never unbounded looping. Slogan: **slice late
(rolling wave), measure early (tests first)** — late slicing keeps a wrong
decomposition's blast radius small, early measuring exposes a wrong
criterion fast. No special machinery is required: pre-placed tests included
in required checks *are* the wall's implementation.

## Four-way misalignment diagnosis

When an outcome misses expectations, split the question four ways. Each
question has a fixed address on the timeline, so the comparison is
mechanical — link-walking, not memory — and can itself be delegated to an
agent:

| # | Question | Address | If it is the culprit |
|---|---|---|---|
| 1 | Was the work order wrong? | Task issue body | fix the issue template / planner quality bar |
| 2 | Did the plan misread it? | plan comment on the issue | fix the agreement the plan leaned on |
| 3 | Did the diff drift from the plan? | PR diff | thicken the wall — add the check that would have caught it |
| 4 | Did verification let it through? | evidence table + checks | add or sharpen the tests |

The four addresses always exist (work order → start → plan → PR → outcome).
The diagnosis output feeds the retro skill: a misalignment diagnosed is a
recurrence prevented.

## Pre-PR checklist (implementer)

1. Stage everything first (`git add`), then run every command in the Task
   issue's **Verification** section and capture real output — the repo's
   self-check scripts scan **git-tracked** files (`git ls-files`), so an
   unstaged new file passes locally and fails in CI.
2. `git status --short` clean; diff confined to the issue's File-ownership
   paths.
3. New logic has tests at the appropriate level (firmware logic: `native`
   env — see `firmware.instructions.md`).
4. Fill the PR template's evidence table — every acceptance criterion gets a
   row:

```markdown
| Criterion | Evidence (command / link) | Result |
|---|---|---|
| REQ-012: pairing completes < 5 s | `npm test -- pairing.spec` -> 8 passed | pass |
| Docs updated | docs/agreements/requirements.md diff in this PR | pass |
| HIL verified on device | n/a in this task -> follow-up #<n> (exec:ide) | deferred |
```

`deferred` is legal only when a follow-up issue exists and is linked;
"pass (untested)" is not a result.

## Reference, don't paste

Evidence often involves real data; real data lives in access-controlled
stores, and the ledger (issues, PRs, commits) carries **links, not
values**. Pasting PII, credentials, tokens, or customer records into an
issue or PR turns the ledger itself into a leak — and gets the PR rejected
(copilot-instructions, rejection list). Sanitized excerpts are fine when
the sanitization is self-evident; when in doubt, link.

## CI failure triage

When a check fails, classify before touching anything:

- **Environment** (missing tool, network, flake): fix the environment —
  usually `.github/workflows/copilot-setup-steps.yml` or CI config — and note
  it as a retro candidate.
- **Defect** (the code is wrong): fix the code.
- **Specification mismatch** (the test encodes a requirement the task was
  told to change, or the requirement itself is wrong): **stop patching.**
  Apply `needs:replan`, record the mismatch on the issue, and let the plan —
  or the agreement — be corrected first. Making a wrong test pass is the most
  damaging "fix" an agent can make.

## Writing good Verification sections (planner)

- Commands must run in the task's routed environment (`exec:cloud` tasks get
  no hardware — split HIL criteria into an `exec:ide` follow-up).
- Prefer commands over prose: "run X, expect Y" beats "make sure it works".
- Include the negative case when it matters ("`grep -R <secret-pattern>`
  returns nothing").
