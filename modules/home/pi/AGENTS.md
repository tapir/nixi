# Global Instructions

## Environment

- The environment you see is an Arch Linux DistroBox container where the $HOME directory is mounted to the host's $HOME directory.
- You are allowed to run "read-only" commands in the host via `distrobox-host-exec` but if you need to run a "write" command in the host, *always* ask the user's permission first.
- You can install packages inside the container. `yay` is installed which is an AUR-aware, `pacman` compatible cli too. `sudo` is passwordless.
- The host is NixOS and its configuration is in ~/Documents/nixi.

## General Rules

- Always use "timeout" for executions and subagents to eliminate calls and subagents getting stuck.
- When doing a git commit do not include a prefix on the description (no "frontend:" or "chore:"), just make it a plain english phrase. Start with uppercase letter. Always explain the git commit in the body.
- Always make sure all warnings and errors are solved before finalizing a task.
- Always use the defined agents whenever possible. For example: coder, scout etc...
- If you need a "durable" session -a session that would survive crashes- you can also spawn your own agents to do arbitrary tasks.

## Markdown Documenting Rules

- When documenting a project never use the *.md file as a changelog. Always keep the *.md file up-to-date with latest changes and do not log the project's history. *.md file should always represent the latest status of the project and nothing else.
- Keep documentation concise.

## Code Commenting Rules

- Default to no comment. Code shows *how*; comment only to carry *why* — a non-obvious constraint, deliberate deviation, gotcha, or workaround.
- Never narrate the code ("loop over users", "parse the body"), restate names/types/signatures, or mark block ends.
- Never narrate the change ("fixed X", "updated to Y", "as requested"). A comment must read correctly to someone seeing the file fresh who never saw the diff; change context belongs in the commit message.
- Delete by default. A comment that just restates a decision the code already reflects — "1 vCPU is deliberate", "right-sized from prod" — is dead weight even when it points to a doc: the doc is where anyone questioning it looks anyway. Keep inline only what a reader needs *at that line* and can't get from the code — a non-obvious invariant/constraint ("timeout must stay < interval — ALB rule") or a cross-file sync obligation ("keep in sync with the router's TGs").
- Comments must stand on their own with any link removed — encode the substance, never a pointer as a substitute for it. Banned: specs, section numbers, design docs — point-in-time artifacts that get superseded and rot ("spec §7" is the canonical case). Fine: a maintained doc/README at a stable path — and when the *why* is a system-level narrative ("why it's built this way"), extract it there as a *pure* extraction: not an inline block, and not a comment that merely points to the doc. What stays inline are the non-obvious local details, which reference the doc only when a reader genuinely needs it *at that line* — a pointer-only comment generally shouldn't exist at all. Tickets, Confluence, RFCs, permalinks stay fine as trailing breadcrumbs.
- Occam's razor on every comment you *keep*, not just the ones you delete. "Carries a real *why*" and "is worded minimally" are independent judgments — a genuine *why* can still be 3x too long, and "it's a real why" is not license to keep the wording verbatim. Keep only the one non-obvious fact a reader needs *at that line*, in the fewest words; cut the mechanism the code already shows, where a value is consumed downstream, the consequence-of-the-consequence, and justification-of-the-justification. A 5-line block almost never survives intact — suspect it on sight; the razored answer is sometimes zero.
- A one-line summary on a public function/endpoint is fine; inline restatement of a single clear line never is.
- TODOs are fine and don't need issue IDs — but a TODO is a marker, not a substitute for doing the work in scope.