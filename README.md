# Agentic Development Scaffold (GitHub-native)

Repository wiring for running an AI-agent development lifecycle on GitHub —
with GitHub Copilot cloud (coding) agent, the GitHub Copilot app's
parent/child sessions, Copilot CLI, and IDE agents — such that **the plan,
the work, the evidence, and the lessons all live on GitHub**, not in chat
windows. Everything here is plain files: version it, review it, and let the
improvement loops evolve it.

Two design premises. First, sessions are ephemeral and agents are stateless,
so GitHub (issues, PRs, committed files) is the only shared memory. Second,
**this scaffold is generic by design**: project truth is injected once,
through the `project-onboarding` skill, and kept honest afterwards by
`scripts/tuning-status.sh` — so the same template serves any project and can
be sharply tuned the moment a target arrives.

## This is a template — after copying

Four steps turn a fresh copy into a licensed working environment:

1. **Bootstrap labels:** `scripts/setup-labels.sh` (the 11 labels the
   skills rely on).
2. **Onboard:** run the `/onboard-project` command — it inventories the
   repo, asks only the gaps, verifies commands by actually running them,
   fills every `CUSTOMIZE` marker, and lands one evidence PR. Merging that
   PR (plus one shakedown delegation) is the **license merge**: unattended
   delegation unlocks here, not before.
3. **Enable the ruleset (human):** `scripts/setup-ruleset.sh` creates the
   branch ruleset *disabled* by design; a human reviews and enables it in
   Settings → Rules → Rulesets.
4. **First Epic:** file an Epic, run `/breakdown-epic`, dispatch the
   frontier, and take one task through plan comment → PR → green checks →
   completion merge.

Until step 2 completes, CI shows `scaffold not onboarded` warnings and
`scripts/tuning-status.sh` lists what remains — an untuned copy is meant
to be machine-visible, not discovered by accident. Full detail for every
step: **Getting started** below.

## The lifecycle

| Phase | What happens | Lives in |
|---|---|---|
| 0. Onboard | Tune the scaffold to the project: inventory → gap interview → run-verified commands → fill every CUSTOMIZE → evidence PR | `project-onboarding` skill, `tuning-status.sh` |
| 1. Collect | Land raw information with provenance | `docs/context/` via `context-collection` skill |
| 2. Distill & agree | Turn raw material into reviewed truth (REQ/ADR/glossary/non-goals) via PR; place each piece of knowledge in a context tier | `docs/agreements/` via `context-distillation` skill |
| 3. Plan & orchestrate | Rolling-wave issue graph (Epics → just-in-time Task sub-issues, `blocked-by` ordering, actionable frontier); parent/child sessions execute it | `plan-management` + `session-orchestration` skills, issue templates |
| 4. Route & execute | Each task carries one `exec:*` label + Routing block deciding surface, role, and model tier | `task-routing` skill, `.claude/agents/` |
| 5. Verify & learn | Layered gates (CI → security → AI review → human), evidence tables, and `retro:` PRs that improve the system itself — upstreaming what is project-agnostic | `verification` + `retro` skills, `ci.yml`, rulesets |

## The Three Merges

Progress is recorded by merges, not conversations. Three checkpoints mark
the lifecycle, and each is the same mechanical act — a pull request merged —
so agreement, trust, and completion all leave the same kind of durable,
reviewable trail:

1. **Agreement merge** — the agreements PR merges (REQ / ADR / glossary /
   non-goals): *what to build* is now recorded truth, and the switch from
   raw input to shared knowledge is complete (phase 2).
2. **License merge** — the onboarding evidence PR merges, carrying
   run-verified commands plus one shakedown delegation (a small task run
   end-to-end from dispatch through draft PR to green CI): the foundation
   is proven by driving it, not by declaring it. Unattended delegation
   unlocks here, and is re-licensed differentially when the foundation
   changes (phase 0β).
3. **Completion merge** — a task's PR merges through the gates (required
   checks plus a non-author approval) and `Closes #<n>` snaps the issue
   shut: *done* is recorded with evidence (phase 5).

Human judgment concentrates at dispatch (what to ask for, when, how much in
parallel) plus these three points; everything between them is delegated to
agents and to walls.

## Repository map

```
AGENTS.md                          Operating constitution (all agents, all surfaces)
CLAUDE.md                          Repo practicalities + @AGENTS.md import (always-on context)
SCAFFOLD-CHANGELOG.md              Template lineage: adopted version, upgrade path
LICENSE                            MIT
.gitignore                         Hygiene: session plan.md, session-scope, local settings
.claude/
  skills/                          Procedures (SKILL.md each):
    project-onboarding/              tune this scaffold to the target project
    context-collection/              intake with provenance
    context-distillation/            agreements + context tiering
    plan-management/                 issue graph, frontier, replanning
      scripts/                         frontier.sh, new-task.sh
      templates/                       canonical epic/task issue bodies
    task-routing/                    exec:* surface, role, model tier
    session-orchestration/           parent/child session protocol
    verification/                    gates, evidence, CI-failure triage
    retro/                           failures -> system improvements (+ upstreaming)
  commands/                        Slash commands: /onboard-project /distill-context
                                   /breakdown-epic /start-task /replan /retro
  agents/                          Role subagents with tool fences: orchestrator, planner, reviewer
  rules/                           Path-scoped rules (docs/, firmware/, code review)
  settings.json                    Permissions + hooks (ownership-guard, session start)
.mcp.json                          Project MCP servers (per-user approval on first use)
.github/
  CODEOWNERS                       Human review gate on docs/agreements/ + workflows/
  dependabot.yml                   Weekly version updates for pinned GitHub Actions
  ISSUE_TEMPLATE/                  Web forms mirroring the canonical bodies
  PULL_REQUEST_TEMPLATE.md         Evidence table + deviations + checklist
  workflows/                       ci.yml (quality + scaffold-self-check jobs),
                                   retro-hygiene.yml (monthly review issue)
scripts/check-md-links.sh          Markdown path references resolve (scaffold-self-check)
scripts/check-template-sync.sh     Issue forms <-> body templates in sync (scaffold-self-check)
scripts/hooks/ownership-guard.sh   PreToolUse hook: the single-writer rule, enforced
scripts/retro-hygiene.sh           Retro candidates + always-on budget report (--create-issue)
scripts/setup-labels.sh            Bootstrap the canonical label set
scripts/setup-project.sh           Bootstrap the optional Projects v2 roadmap board
scripts/setup-ruleset.sh           Bootstrap the branch ruleset — Getting started step 5 (created disabled)
scripts/tuning-status.sh           Tuned or not? (report / --ci / --quiet)
docs/context/                      Phase-1 raw intake
docs/agreements/                   Phase-2 reviewed truth (+ retro-log.md)
```

## Conventions at a glance

- **Unit of work:** 1 Task issue = 1 session = 1 worktree/branch
  (`task/<issue-number>-<short-slug>`) = 1 PR (`Closes #<n>`).
- **Labels:** `type:epic`, `type:task`, `ai:ready`, `needs:human`,
  `needs:replan`, and exactly one of `exec:cloud | exec:app | exec:cli |
  exec:ide` per task.
- **Task issue sections (parsed — do not rename):** Objective, Context &
  references, Acceptance criteria, Out of scope, File ownership,
  Verification, Routing, Handoff notes.
- **Frontier** (what may run now): open `type:task` issues labeled
  `ai:ready` whose `blocked by` issues are all closed —
  `.claude/skills/plan-management/scripts/frontier.sh`.
- **Reporting:** record-before-report (issue comment first, session message
  second) and verify-before-done (`gh`/`git` ground truth, never memory).
  A task's timeline reads start → plan → outcome; the issue body is the
  requester-owned work order and is never edited by the executing agent.

## How context reaches an agent (tiering)

Always-on files (`AGENTS.md`, `CLAUDE.md`) stay lean and
universal; path-scoped `.claude/rules/` files load only for matching
paths; skills load on demand by description; task-specific context travels
in the Task issue itself. The `context-distillation` skill owns tier
placement; the `retro` skill's Budget rule keeps always-on files from
bloating. Resist the urge to put everything in always-on context — it
degrades every request a little.

## Getting started

1. **Instantiate:** use the template repository (or copy this tree into your
   repo root), commit, push. Until onboarding completes, CI shows
   `scaffold not onboarded` warnings and agents are told not to trust the
   command sections.
2. **Bootstrap labels:** `scripts/setup-labels.sh` (or `-R owner/repo`).
3. **Onboard:** run the `/onboard-project` command (or hand any capable
   agent `.claude/skills/project-onboarding/SKILL.md`). It inventories the
   repo, asks only the gaps, verifies commands by running them, fills or
   removes every `CUSTOMIZE` block across the Sync Pair
   (`CLAUDE.md` ⇄ `ci.yml`), and opens one evidence PR. Manual fallback: search the repo for `CUSTOMIZE`
   and fill by hand. Tuned = `scripts/tuning-status.sh` exits 0.
4. **MCP:** Claude Code sessions read the checked-in `.mcp.json`
   (project-scoped; each user approves it on first use). Scope each server
   to the minimal tool set a task genuinely needs, and prefer per-project
   additions via PR over ad-hoc local config — the ledger should show which
   servers agents could reach.
5. **Branch ruleset** on `main`: require a pull request; require the CI
   checks from `ci.yml`; require at least one approval from someone other
   than the author (this is what makes agent PRs human-gated); optionally
   restrict who can modify `.github/workflows/` and `docs/agreements/`.
   `scripts/setup-ruleset.sh` scripts this: it creates the ruleset with
   enforcement disabled, so a human reviews and enables it in repository
   settings (Settings → Rules → Rulesets) before it gates anything.
6. *(Optional)* bootstrap a Projects v2 roadmap board:
   `scripts/setup-project.sh init` creates (or reuses)
   "<repo> roadmap" with `Start date` / `Target date` fields plus a `Kind`
   single-select field (Epic/Task) and links it to the repo; schedule
   issues with the `dates` subcommand, which also sets `Kind` from the
   `type:epic` / `type:task` labels. The board is owned by the repo owner
   by default (Projects v2 boards are always user/org-owned) and the repo
   link makes it visible in the repository's Projects tab. Manual steps
   remain — create the Roadmap view in the project UI and group it by
   `Kind` (see
   `.claude/skills/plan-management/SKILL.md`, Roadmap scheduling). At org
   level you can additionally define issue types (Epic/Task) and a Project
   with a Blocked view; keep Project fields derived from issues.
7. **First run:**
   - Collect sources into `docs/context/<topic>/` (`context-collection`).
   - Run `/distill-context` → agreements PR → human merges (= agreement).
   - File an Epic (form or
     `.claude/skills/plan-management/templates/epic-body.md`).
   - Run `/breakdown-epic` → approve → Task issues exist, wired and routed.
   - Dispatch the frontier: `exec:cloud` → assign the issue to Copilot;
     `exec:app` → open a parent session with the **orchestrator** agent and
     let it spawn one child session per task (`/start-task` inside each);
     `exec:ide` → a human pairs in the IDE (hardware work lands here).
   - PRs flow through the gates; on deviations run `/replan`; periodically
     run `/retro` so the system learns. The monthly `retro-hygiene`
     workflow (`.github/workflows/retro-hygiene.yml`) files the
     `Retro hygiene review <YYYY-MM>` issue automatically, surfacing
     promotion-overdue retro candidates and always-on budget drift.

## Scaffold lineage & upgrades (the second loop)

Within a project, the `retro` skill evolves this wiring via `retro:` PRs.
Across projects, improvements flow both ways through the template
repository: project-agnostic retro fixes are **upstreamed** (retro skill,
Upstreaming section), and instances **upgrade** by diffing against template
tags and cherry-picking while keeping their tunings — procedure and version
history in `SCAFFOLD-CHANGELOG.md`. Rule of thumb: procedures, templates,
and gates are upgradable; the Sync Pair content and `paths` globs are
project truth and stay put.

## Terminology bridge (JP ↔ EN)

The scaffold's core concepts carry established Japanese names in the
companion literature; one line each:

| Japanese | English (this repository) |
|---|---|
| 三つのマージ | the Three Merges (agreement / license / completion) |
| 先置きテスト | test-first work orders |
| 追跡グラフ | tracking graph |
| 台帳の完全性 | ledger completeness |

## Origin note

Consolidated from tt1 (scaffold v0.6.0) + 2026-08-02 design review; the
version trail lives in `SCAFFOLD-CHANGELOG.md`. Conventions here encode one
team's answers to: "how do we stay oriented when many agents work in
parallel?" (issue graph + frontier + record-before-report), "how do we
switch tools without re-briefing?" (routing labels + shared
instructions/skills read by every surface), and "how do we keep agents
honest?" (evidence tables + verify-before-done + layered gates). Adjust via
PRs; log the reasons in `docs/agreements/retro-log.md`.
