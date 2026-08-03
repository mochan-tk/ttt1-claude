<!-- Canonical Task issue body. Mirrors .github/ISSUE_TEMPLATE/ai-task.yml.
     Used when creating Task issues via gh CLI / new-task.sh (issue forms
     apply only to the web UI). Keep the section headings exactly as below —
     agents and scripts parse them. Delete all comments before filing. -->

## Objective

<!-- One sentence: the observable outcome this task delivers. -->

## Context & references

<!-- Links the executing agent must read: REQ-### entries, ADRs, parent Epic,
     prior PRs/issues, relevant docs/context files. Assume the agent sees
     NOTHING beyond this issue and these links. Derived issues
     cite the origin as #N in one line ("found while working #N") — that
     single line keeps the tracking graph connected (plan-management skill). -->

- Epic: #
- Requirements: REQ-
- Decisions:

## Acceptance criteria

<!-- Write each criterion as an executable check (test or command) placed
     before implementation — "these turn green" is this task's definition of
     done; the checks join the wall (verification skill, Test-first work
     orders). Reference REQ-### where applicable; an observable artifact is
     acceptable only where no check can encode it. -->

- [ ]
- [ ]

## Out of scope

<!-- Explicit non-goals for THIS task. The cheapest scope-creep guard. -->

-

## File ownership

<!-- Paths (globs allowed) this task may modify. The diff must stay inside
     them (AGENTS.md §5). Parallel tasks must not overlap. -->

-

## Verification

<!-- How to run the pre-placed acceptance checks (commands with expected
     results), executable on the routed surface (exec:cloud tasks get no
     hardware). -->

```bash

```

## Routing

<!-- See .github/skills/task-routing/SKILL.md. Mirror Surface as the exec:*
     label on the issue. -->

- Surface: exec:cloud | exec:app | exec:cli | exec:ide
- Suggested role: default | planner | orchestrator | reviewer
- Model/reasoning tier: high-reasoning | standard | fast | local
- Parallel-safe: yes | no — <why>

## Handoff notes

<!-- Optional: state another agent would need to take over or follow up. -->

-
