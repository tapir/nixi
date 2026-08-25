# Global Instructions

## Environment

- The environment you see is an Arch Linux docker container where the $HOME directory is mounted to the host's $HOME directory.
- You can ask user to install packages inside the container.
- The host is NixOS and its configuration is in ~/Documents/nixi.

## Delegation (pi-subagents)

- Before planning work in an unfamiliar codebase, delegate to `scout` for recon.
- Before trusting external facts (docs, APIs, versions, news), delegate to `researcher` or use `web_search` for quick lookups.
- For well-scoped implementation tasks, delegate to `worker`.
- Architecture phase: gather context with `scout`, draft the design, then consult `oracle` to stress-test it (hidden assumptions, conflicts with existing decisions, tradeoffs). Use follow-up consultation rounds for material tradeoffs. Only proceed to implementation after oracle concerns are addressed.
- After finishing an implementation, run `reviewer` on the changes before summarizing.
- Keep quick one-off chores in the main session; delegate when the work would clutter context or benefits from a fresh perspective.

## Web research (pi-web-access)

- Use `web_search` for quick factual lookups; prefer the `researcher` subagent for multi-source research that needs a brief with citations.
