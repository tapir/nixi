# Global Instructions

## Environment

- The environment you see is an Arch Linux docker container where the $HOME directory is mounted to the host's $HOME directory.
- You can ask user to install packages inside the container. `yay` is installed which is an AUR-aware, `pacman` compatible cli too.
- The host is NixOS and its configuration is in ~/Documents/nixi.

## General Rules

- Always use "timeout" for executions to eliminate calls getting stuck.
- When doing a git commit do not include a prefix on the description (no "frontend:" or "chore:"), just make it a plain english phrase. Start with uppercase letter.
- Always explain the git commit in the body.
- Always make sure all warnings and errors are solved before finalizing a task.

## Code Commenting Rules

- Only comment when the code cannot express intent itself. If a good identifier or structure makes the comment redundant, delete it.
- Never write "change history" comments: no "was // now //", no dates, no "changed from X to Y", no TODO-as-journal, no "Refactored" notes.
- Never restate the code (`// increments i`). Explain the *why* the code exists, not the *what* it does.
- One line, imperative, lowercase start, no trailing period. If a comment needs two sentences, it's a smell — rewrite the code instead.
- Explain non-obvious things only: tricky edge cases, a workaround for a bug in a dependency, performance decisions, a business rule that looks wrong on purpose.
- To-be-done must say *what and why*, not that it's pending: `// TODO: reject after 30 days — legal requires it` not `// TODO`. No bare TODOs. No "later". No "this could be better".
- Before adding a comment, ask: would a future reader reach the wrong conclusion without it? If they'd correctly *derive* it, don't write it.