# Scaffold Changelog & Lineage

This repository is the **ADLC template scaffold** — the template other
projects copy (via GitHub's Template repository setting, or by copying the
tree). This file tracks the template's own versions, the procedure a copied
instance uses to move between them, and where these files came from. A
project's own changelog, if any, lives elsewhere — this file is about the
scaffolding only.

**Scaffold version adopted by this instance:** v2.0.0
*(in the template repository this line always names the latest version;
in a copied instance, update it when upgrading — the onboarding PR should
confirm it)*

## Upgrading an instance

1. Diff this instance against the template tag you are moving to
   (e.g., `git remote add scaffold <template-url> && git fetch scaffold --tags
   && git diff scaffold/v1.0.0..scaffold/v1.1.0 -- . ':!docs/context' ':!docs/agreements'`).
2. Cherry-pick or apply the changes, **keeping project tunings** (the Sync
   Pair content, `paths` globs, layout map) — upgrades change
   procedures and templates, not your project truth.
3. Re-run `scripts/tuning-status.sh` and the CI gates.
4. Land as one PR titled `scaffold: upgrade to vX.Y.Z`; append a
   `docs/agreements/retro-log.md` row (class `scaffold-upgrade`).

## Upstreaming (instance → template)

The mechanism is one question. When an instance PR touches agent-behavior
files (instructions, `AGENTS.md`, prompts, agents, skills, workflows, MCP
config), ask **once per PR**: "reflect this in the template too?" — and
record the answer in the PR description in fixed form (`upstream:
proposed <URL>` / `upstream: not-applicable — <reason>`). If proposed, open the matching PR on the
template repository and mark the retro-log Fix cell `[upstreamed]` — see
`.claude/skills/retro/SKILL.md`, Upstreaming. Acceptance is the template
owner's call (merge right = judgment right); the instance PR never waits
for it. That is how future projects inherit what this one learned.

## Versions

### v2.0.0 — 2026-08-03

Claude-first restructure (ADR-0001) + cross-template hardening (ADR-0002),
built as Epic mochan-tk/ttt1-claude#14 with the agreement merge first.
**Layout-breaking for v1.x instances** — upgrade note below.

- Claude-native execution plane: skills moved to `.claude/skills/` (single
  source); six native slash commands in `.claude/commands/`; the three
  roles as tool-fenced subagents in `.claude/agents/` (no file editor);
  path-scoped rules in `.claude/rules/` (`paths:` frontmatter);
  `.claude/settings.json` with permissions + hooks (ownership-guard
  enforcing the single-writer rule from `.claude/session-scope`;
  session-start tuning reminder; force-push deny); `.mcp.json`.
- `CLAUDE.md` rewritten as the repository-practicalities file importing
  `AGENTS.md`; the Copilot surfaces removed with behavior translated (the
  Copilot instructions file, prompts/agents/instructions directories, the
  setup-steps workflow, the VS Code MCP config). Sync Triangle → **Sync
  Pair** (`CLAUDE.md` ⇄ `ci.yml`); routing table retargeted to Claude Code
  surfaces.
- Hardening adopted from the ttt1-codex comparison line (ADR-0002):
  frontier `type:task` filter (defect fix) + loud bounds; `new-task.sh`
  exclusive `--dry-run`/`--apply` boundary with full preflight and
  `--origin`/`--risk`; `setup-project.sh` field-type preflight;
  `setup-labels.sh` `--dry-run`; required Origin + Risk-gate fields in the
  task form; deferred-criteria block completion; mechanical same-failure
  definition; exact-plan-URL risk approval; one-line `upstream:` PR
  contract.
- README and changelog restructured Claude-first (intro, enforcement
  section, tiering, comparison provenance; mochan-tk/ttt1-claude#18).
- Retro (in-wave): stage before running the self-check suite
  (mochan-tk/ttt1-claude#22, promoted at two occurrences);
  `check-md-links` now covers `.claude/` paths.
- **Upgrading a v1.x instance:** move any local skill edits from the old
  skills tree into `.claude/skills/`, port instructions-file tunings into
  `CLAUDE.md` and `.claude/rules/`, re-run `scripts/setup-labels.sh`, then
  follow "Upgrading an instance" above (tag diff v1.0.0 → v2.0.0).

### v1.0.0 — 2026-08-03

Consolidated template baseline: tt1 (scaffold v0.6.0) + the 2026-08-02
ADLC design review (deltas D1–D10). Fresh history; tt1's version-by-version
trail is summarized under Lineage below.

- Skeleton ported from `mochan-tk/tt1` branch `retro/plan-comment-landing`
  (v0.6.0): AGENTS.md constitution (§1–§9), eight skills, three roles, six
  prompts, issue forms + PR template, CI (`scaffold-self-check`),
  retro-hygiene automation, setup scripts, the CUSTOMIZE marker +
  `tuning-status.sh` mechanism, CLAUDE.md shim, docs tree, hygiene files
  (CODEOWNERS, dependabot, .gitignore).
- MIT `LICENSE` added.
- Design deltas D1–D10 (2026-08-02 review), merged under Epic
  mochan-tk/ttt1-claude#1:
  - D1 the Three Merges named in the README concept layer (agreement /
    license / completion; human judgment = dispatch + three points).
  - D2 test-first work orders: acceptance criteria land as pre-placed
    executable checks (form, template, verification skill; "slice late,
    measure early").
  - D3 tracking graph: four edges, one rule — derived issues cite the
    origin as #N in one line (plan-management, task form).
  - D4 four-way misalignment diagnosis: work order / plan comment / diff /
    evidence & checks (verification skill).
  - D5 intervention forks (revised-plan comment | body edit + change
    comment | issue-first) + `risk:high` exception gate (plan-management,
    session-orchestration, setup-labels — 11 labels).
  - D6 crash-only resume protocol: start ritual + derivation, orphan
    detection by parent, resume-comment ownership transfer
    (session-orchestration).
  - D7 §10 ledger completeness in AGENTS.md ("hands off, voice on").
  - D8 reference-don't-paste: PII/credentials never pasted into the ledger
    (the always-on instructions file's rejection list, verification skill).
  - D9 existing-codebase path: characterization tests first
    (project-onboarding).
  - D10 re-registered `retro:candidate` seed: auto-comment issue-body
    edit diffs (mochan-tk/ttt1-claude#10, not built).
- README onboarding funnel ("This is a template — after copying") and the
  JP↔EN terminology bridge — the scaffold's only sanctioned Japanese —
  under the same Epic.

## Lineage (pre-v1.0.0, inherited from tt1)

This scaffold consolidates `mochan-tk/tt1`. Its version trail, kept here
because it is the traceable origin of the current rules:

- **v0.6.0 — 2026-08-02** — plan-comment landing: a task's timeline becomes
  the single diagnosis trail (work order → start → plan → outcome); plans
  land as Task-issue comments before the first commit; executing agents
  never edit their own work order; body edits require a change comment
  (mochan-tk/tt1#39).
- **v0.5.0 — 2026-07-04** — self-tuning loop: `retro:candidate` ledger,
  deterministic monthly `retro-hygiene` report + issue, live retro demo on
  a real deviation (mochan-tk/tt1#20 – mochan-tk/tt1#22).
- **v0.4.0 — 2026-07-04** — `scripts/setup-project.sh`: optional Projects
  v2 roadmap bootstrap with Start/Target date fields (mochan-tk/tt1#16).
- **v0.3.0 — 2026-07-04** — `scaffold-self-check` CI (pinned shellcheck +
  actionlint, template-sync and md-link checks), hygiene files,
  `setup-ruleset.sh` (created disabled), atomic `new-task.sh` wiring,
  bash-3.2 empty-array guards (mochan-tk/tt1#7 – mochan-tk/tt1#11).
- **v0.2.x — 2026-07-03** — `project-onboarding` skill + `/onboard-project`
  prompt + `tuning-status.sh` (tuning as a verified procedure); second
  improvement loop (upstreaming + lineage file); `CLAUDE.md` shim.
- **v0.1.0 — 2026-07-03** — initial 40-file scaffold: constitution, seven
  skills, three roles, five prompts, issue forms + PR template, CI
  placeholders, docs tree, label bootstrap.
