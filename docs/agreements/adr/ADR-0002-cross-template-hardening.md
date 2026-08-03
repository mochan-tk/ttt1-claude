# ADR-0002: Cross-template hardening adoption

- **Status:** accepted
- **Date:** 2026-08-03
- **Supersedes:** none

## Context

The comparison experiment's value is cross-pollination: each line learns
from the others' incidents without repeating them. Auditing ttt1-codex
(2026-08-03) surfaced platform-neutral mechanics that are strictly safer
than this repository's v1.0.0 equivalents — several of them born from a
real incident there (mock-interception failure created live Issues
mochan-tk/ttt1-codex#8 and mochan-tk/ttt1-codex#10; the second occurrence was promoted, per the retro
two-occurrence rule, into a fail-closed creation gate). The same audit
found a real defect on this side: `frontier.sh` **omits the `type:task`
filter**, so a mislabeled or epic-typed issue that is open + `ai:ready` +
unblocked would be dispatched as work.

## Decision

Adopt the following, translating semantics into this repository's house
style (bash-3.2 guards, comment conventions), not copying code:

| # | Item | Provenance |
|---|---|---|
| 1 | `frontier.sh`: `type:task` filter (defect fix); >200-candidate loud-failure sentinel; visible dependency-lookup errors | ttt1-codex `frontier.sh`; defect found in this repo's copy |
| 2 | `new-task.sh`: mandatory exclusive `--dry-run`/`--apply` (live-GitHub boundary); `--apply` preflight (gh capability, parent is `type:epic`, blockers/origin readable, labels exist); `--origin`/`--risk` flags | ttt1-codex incident (mochan-tk/ttt1-codex#8, mochan-tk/ttt1-codex#10) → fail-closed gate |
| 3 | `setup-project.sh`: field-type preflight (same-name field of wrong type hard-fails, never silently reused); `setup-labels.sh`: `--dry-run`/`--help` | ttt1-codex setup scripts |
| 4 | Task form + body template: required **Origin** input ("#N — discovered while ..."), required **Risk gate** selection | ttt1-codex `task.yml` |
| 5 | Verification skill: a `deferred` acceptance criterion **blocks the completion merge** (a linked follow-up issue is required to defer, and the Outcome cannot claim completed with an unlinked deferral) | ttt1-codex PR mochan-tk/ttt1-codex#12 revised plan |
| 6 | Same-failure definition for escalation counting: same command/check **and** same root-cause signature; counters reset only on materially different intervention | ttt1-codex REQ-022 |
| 7 | Risk-gate approval format: a human approval comment quoting the **exact plan-comment URL**; a revised plan requires fresh approval | ttt1-codex ADR-0002 §2 |
| 8 | PR template: exactly one `upstream: proposed <URL> \| not-applicable — <reason>` line; checklist gains "plan comment predates implementation" | ttt1-codex PR template |

Explicitly **not** adopted: `.codex/`/`.agents/` layouts and
`agents/openai.yaml` metadata (Codex plumbing; ADR-0001 owns the Claude
equivalents); dropping CI (ttt1-codex ships no workflows — this
repository's deterministic wall stays).

## Consequences

- Task creation can no longer half-wire an issue or touch live GitHub from
  a rehearsal; the frontier can no longer dispatch non-task issues.
- Slightly heavier authoring (Origin and Risk are now required thinking,
  not optional hygiene) — accepted: both fields are one line each.
- Implementation lands in task #17; the retro-log records the frontier
  defect with this ADR as the fix's origin.

## References

- Epic mochan-tk/ttt1-claude#14; audit recorded in that epic's task PRs
- ttt1-codex sources (external repository —
  <https://github.com/mochan-tk/ttt1-codex>): the plan-management skill
  scripts (`frontier.sh`, `new-task.sh` under `.agents/skills/`), the task
  issue form, the PR template, ADR-0002 "adlc-operating-model", Issues
  mochan-tk/ttt1-codex#8 / mochan-tk/ttt1-codex#10, PR
  mochan-tk/ttt1-codex#12
