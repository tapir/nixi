# Global Instructions

## Environment

- The environment you see is an Arch Linux docker container where the $HOME directory is mounted to the host's $HOME directory.
- You can ask user to install packages inside the container.
- The host is NixOS and its configuration is in ~/Documents/nixi.

## Rules

- Always use "timeout" for executions to eliminate calls getting stuck.
- When doing a git commit do not include a prefix on the description (no "frontend:" or "chore:"), just make it a plain english phrase.
- Always explain the git commit in the body.