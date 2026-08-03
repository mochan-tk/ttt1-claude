---
description: Start work on a Task issue following the child-session start ritual (read brief, load references, claim the issue, record the ownership scope).
argument-hint: [issue-number]
---

Follow the child session protocol in
`.claude/skills/session-orchestration/SKILL.md`.

Task issue number: $1

1. `gh issue view $1` — read the complete brief.
2. Open every referenced agreement/REQ/ADR. If anything is missing or
   contradictory, stop and raise it with me instead of guessing
   (Ambiguity rule, `AGENTS.md`).
3. Restate back to me, briefly: the acceptance criteria, the File-ownership
   paths, and the Verification commands — so we both confirm the same
   understanding of "done".
4. Write the issue's File-ownership globs to `.claude/session-scope`, one
   per line (gitignored) — the ownership-guard hook enforces them from now
   on (`.claude/settings.json`). Dialect: `**` = whole tree, `dir/**` =
   subtree under a literal prefix, other globs are shell-matched with `*`
   crossing `/` — keep scopes as plain directory subtrees where possible.
5. Create branch `task/$1-<short-slug>` (in a fresh worktree if other tasks
   run in parallel), write `plan.md` (session cache — do not commit), and
   comment on the issue that work is starting with the session/branch
   reference.
6. Post the plan comment on the issue (plan of record), honor the
   `risk:high` gate if labeled, and then begin, staying strictly inside the
   ownership paths.
