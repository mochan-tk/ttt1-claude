# Scaffold Changelog & Lineage

This repository is the **ADLC template scaffold** — the template other
projects copy (via GitHub's Template repository setting, or by copying the
tree). This file tracks the template's own versions, the procedure a copied
instance uses to move between them, and where these files came from. A
project's own changelog, if any, lives elsewhere — this file is about the
scaffolding only.

**Scaffold version adopted by this instance:** v1.0.0
*(in the template repository this line always names the latest version;
in a copied instance, update it when upgrading — the onboarding PR should
confirm it)*

## Upgrading an instance

1. Diff this instance against the template tag you are moving to
   (e.g., `git remote add scaffold <template-url> && git fetch scaffold --tags
   && git diff scaffold/v1.0.0..scaffold/v1.1.0 -- . ':!docs/context' ':!docs/agreements'`).
2. Cherry-pick or apply the changes, **keeping project tunings** (the Sync
   Triangle content, `applyTo` globs, layout map) — upgrades change
   procedures and templates, not your project truth.
3. Re-run `scripts/tuning-status.sh` and the CI gates.
4. Land as one PR titled `scaffold: upgrade to vX.Y.Z`; append a
   `docs/agreements/retro-log.md` row (class `scaffold-upgrade`).

## Upstreaming (instance → template)

When a retro fix is project-agnostic, open a matching PR on the template
repository and mark the retro-log Fix cell `[upstreamed]` — see
`.github/skills/retro/SKILL.md`, Upstreaming. That is how future projects
inherit what this one learned.

## Versions

### v1.0.0 — in progress (release date set at tag time)

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
- Design deltas D1–D10 from the 2026-08-02 review land in subsequent task
  PRs under Epic mochan-tk/ttt1-claude#1 and are appended here as they
  merge.

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
  a real deviation (mochan-tk/tt1#20–#22).
- **v0.4.0 — 2026-07-04** — `scripts/setup-project.sh`: optional Projects
  v2 roadmap bootstrap with Start/Target date fields (mochan-tk/tt1#16).
- **v0.3.0 — 2026-07-04** — `scaffold-self-check` CI (pinned shellcheck +
  actionlint, template-sync and md-link checks), hygiene files,
  `setup-ruleset.sh` (created disabled), atomic `new-task.sh` wiring,
  bash-3.2 empty-array guards (mochan-tk/tt1#7–#11).
- **v0.2.x — 2026-07-03** — `project-onboarding` skill + `/onboard-project`
  prompt + `tuning-status.sh` (tuning as a verified procedure); second
  improvement loop (upstreaming + lineage file); `CLAUDE.md` shim.
- **v0.1.0 — 2026-07-03** — initial 40-file scaffold: constitution, seven
  skills, three roles, five prompts, issue forms + PR template, CI
  placeholders, docs tree, label bootstrap.
