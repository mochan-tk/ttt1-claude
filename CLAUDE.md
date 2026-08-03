@AGENTS.md

# Repository Practicalities

Trust this file. Search the codebase only when something here is missing or
demonstrably wrong — and when that happens, propose a fix to this file as
part of your PR (see the retro skill). `AGENTS.md` (imported above) defines
the operating constitution; this file adds the operational details an agent
needs to work efficiently in this repository.

## Repository layout

- `docs/context/` — raw collected material.
- `docs/agreements/` — reviewed requirements, ADRs, glossary, non-goals.
- `.claude/skills/` — procedures. `.claude/rules/` — path-scoped rules.
- `.claude/agents/` — role subagents (orchestrator, planner, reviewer).
- `.claude/commands/` — slash commands (`/onboard-project`, `/start-task`, …).
- `.claude/settings.json` — permissions and hooks (mechanical enforcement).

## Environment setup and validated commands

If `CUSTOMIZE` markers remain in this file (check with
`scripts/tuning-status.sh`), this repository has **not been onboarded** —
run `.claude/skills/project-onboarding/SKILL.md` before trusting or
extending the commands below.

<!-- CUSTOMIZE: Keep this map accurate; it saves agents expensive exploration.
     Replace this block during onboarding with the project's real layout
     additions (source areas, test dirs, build outputs). -->

<!-- CUSTOMIZE: Replace with commands verified to work in a clean environment,
     in dependency order (setup, build, lint, test), each with its expected
     result. Keep in sync with .github/workflows/ci.yml (the Sync Pair). -->

Run steps in this order. Do not improvise alternative commands when these work.

## Working a Task issue

The Task issue body is your work order: you read it, you never edit it
(AGENTS.md §5). It follows `.github/ISSUE_TEMPLATE/ai-task.yml` and
contains: Objective, Context & references, Origin, Acceptance criteria,
Out of scope, File ownership, Verification, Risk gate, Routing, and
Handoff notes. Read all of it before writing code.

1. Comment on the issue that you are starting (one line is enough).
2. Before changing any file, post your implementation plan as a comment on
   the issue — the plan of record (format:
   `.claude/skills/session-orchestration/SKILL.md`). If the plan changes
   materially later, post an update comment.
3. Work on branch `task/<issue-number>-<short-slug>`. Touch only paths
   listed under **File ownership** (the `/start-task` command records them
   in `.claude/session-scope`, and the ownership-guard hook enforces them).
4. Keep the PR description synchronized with reality: map each acceptance
   criterion to evidence using the table in the PR template, and link the
   plan comment (auto-written plan text in the description is a copy — the
   issue comment stays authoritative).
5. Run every command in the issue's **Verification** section before marking
   the PR ready (stage first — the self-check scripts scan tracked files).
   If a command fails, fix the cause or report the blocker — never delete
   or weaken the check.
6. If the task turns out to be materially different from its description,
   follow the Ambiguity rule in `AGENTS.md` (comment, label `needs:human`
   or `needs:replan`, stop).
7. Finish with the record-before-report comment on the issue: status,
   evidence, deviations, follow-ups (format in
   `.claude/skills/session-orchestration/SKILL.md`).

## Pull request conventions

- Title: imperative mood, mirrors the Task issue title.
- Body: fill `.github/PULL_REQUEST_TEMPLATE.md` completely, including
  `Closes #<n>` and the evidence table.
- Keep PRs reviewable: one Task issue per PR; if the diff exceeds roughly
  400 changed lines outside generated code, propose splitting via
  `needs:replan` instead of pushing on.

## Things that will get your PR rejected

- Diff touches paths outside the issue's File ownership section.
- Acceptance criteria without evidence, or verification commands not run.
- Secrets, tokens, or credentials in code or config.
- PII, credentials, or real user/customer data pasted into the ledger
  (issues, PR text, commit messages) — link the access-controlled source
  instead (reference, don't paste; verification skill).
- Modified CI workflows, rulesets, or checks without an explicit mandate.
- Non-English persistent artifacts (code comments, docs, commit messages).
