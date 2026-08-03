# ADR-0001: Claude-native two-plane architecture

- **Status:** accepted
- **Date:** 2026-08-03
- **Supersedes:** none (supersedes the v1.0.0 handoff assumption of
  identical cross-agent file layouts, per the owner decision below)

## Context

This template is one line of a three-way comparison experiment: independent
ADLC templates built with Codex, Claude, and GitHub Copilot, then used. The
owner decided (recorded first in ttt1-codex ADR-0001, reconfirmed for this
repository on 2026-08-03): what the lines share are **ADLC outcomes and
evaluation criteria, not implementation files**. Each line specializes its
execution surfaces for its agent.

v1.0.0 of this repository was Claude-*compatible* but not Claude-*native*:
its only Claude surface was the `CLAUDE.md` import shim, while skills,
prompts, roles, path-scoped rules, and MCP config lived in Copilot-native
locations that Claude Code does not enumerate — skills never auto-triggered,
prompts were not slash commands, roles were not spawnable subagents.

Claude Code's repository-scoped surfaces (verified against
code.claude.com/docs, 2026-08-03): `CLAUDE.md` with `@` imports;
`.claude/skills/*/SKILL.md`; `.claude/commands/*.md`; `.claude/agents/*.md`
with enforceable `tools:` restrictions; `.claude/rules/*.md` with `paths:`
globs; `.claude/settings.json` (permissions and PreToolUse/SessionStart
hooks); `.mcp.json`. The docs state plainly that `CLAUDE.md` is context,
not enforcement — blocking requires hooks.

## Decision

Adopt two cooperating planes:

1. **GitHub control plane — mandatory.** Issues, forms, labels,
   sub-issues, and dependencies encode work and the tracking graph.
   Branches, pull requests, reviews, CODEOWNERS, and closing links encode
   change and the Three Merges. Actions, required checks, rulesets, and
   Dependabot provide deterministic enforcement. Projects stays a derived
   view. This plane is authoritative; sessions and plans are caches.
2. **Claude execution plane — native.** `AGENTS.md` (constitution) +
   `CLAUDE.md` (repo practicalities, importing `AGENTS.md`) as always-on
   context; `.claude/skills/` as the single home of skills;
   `.claude/commands/` for the slash-command catalog; `.claude/agents/`
   for the three roles **with mechanically enforced tool restrictions**
   (orchestrator/planner/reviewer roles carry no edit tools);
   `.claude/rules/` for path-scoped rules; `.claude/settings.json` for
   permissions and hooks; `.mcp.json` for project MCP servers.

Copilot-specific surfaces are **removed, with behavior translated, never
files copied**: the Copilot repository-instructions file (its content moves
into `CLAUDE.md`), the prompts, agents, and instructions directories that
lived under `.github/`, the Copilot setup-steps workflow, and the VS Code
MCP config. The former Sync Triangle becomes the **Sync Pair**
(`CLAUDE.md` ⇄ `ci.yml`).

**Hooks-as-enforcement principle:** the scaffold's thesis — automated
checks are the ceiling on agent autonomy — applies to the agent itself.
Where a constitutional rule can be checked deterministically at tool-use
time (single-writer path ownership, force-push bans), a
`.claude/settings.json` hook enforces it; prose remains for what hooks
cannot decide.

GitHub capability contract:

| Capability | Required ADLC role |
|---|---|
| Git history, versioned agreements, tags | Reviewed truth and upgrade provenance |
| Issues, forms, comments, labels, sub-issues, dependencies | Work orders, plans, outcomes, tracking graph |
| Mechanically calculated frontier | Runnable Tasks from Issue state, never session memory |
| Pull requests, evidence tables, reviews, CODEOWNERS, `Closes #N` | Change, human judgment, the Three Merges |
| Actions, required checks, rulesets | The deterministic verification wall |
| Projects and fields | Derived views only, never planning truth |

## Consequences

- Claude Code sessions get native skill auto-triggering, slash commands,
  spawnable role subagents with real tool fences, path-scoped rules, and
  visible MCP — parity with what `.codex/` gives Codex, plus hook
  enforcement no other line currently has.
- Instances copied from v1.x must follow the v2.0.0 upgrade note in
  `SCAFFOLD-CHANGELOG.md` (layout-breaking).
- The Copilot-flavored ancestry remains available in the lineage (tt1 and
  the v1.0.0 tag); the Copilot line of the experiment owns those surfaces.
- Follow-ups: tasks #16 (plane build + removals), #17 (hardening), #18
  (docs), #19 (release).

## References

- ttt1-codex ADR-0001, "codex-native-architecture", under that
  repository's agreements tree (owner decision superseding layout
  identity; two-plane model): <https://github.com/mochan-tk/ttt1-codex>
- Epic mochan-tk/ttt1-claude#14; prior epic mochan-tk/ttt1-claude#1
- k-wk4-codex `docs/decisions/ADR-0006` (ADLC completion design)
- code.claude.com/docs (Claude Code repository surfaces, checked 2026-08-03)
