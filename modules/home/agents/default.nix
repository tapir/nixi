# ~/.agents — pi subagent profiles.
#
# Nix-managed symlinks, so the payloads next to this module are the single
# source of truth. pi-subagents' own agent editor writes these paths in
# place; against a store symlink that write fails instead of silently
# drifting from the repo. Edit here and re-run nixswitch.
#
# The rest of ~/.agents (skills/) stays unmanaged.

{
  home.file = {
    ".agents/coder-c.md".source = ./coder-c.md;
    ".agents/coder-go.md".source = ./coder-go.md;
    ".agents/coder-rust.md".source = ./coder-rust.md;
    ".agents/coder-python.md".source = ./coder-python.md;
    ".agents/scout.md".source = ./scout.md;
  };
}
