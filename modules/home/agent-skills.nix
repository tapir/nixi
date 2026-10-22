# Agent skills for pi, fetched from upstream repos and symlinked into
# ~/.agents/skills (replaces `npx skills add`). Pi reads that directory
# natively; skills are plain data so nix symlinks are safe.
#
# Unpinned fetchGit tracks each repo's default branch, so every rebuild
# picks up the latest — which pure evaluation refuses. The nixswitch /
# nixboot aliases pass --impure for this reason; flake inputs stay locked.

{ config, lib, ... }:

let
  fetch =
    url:
    builtins.fetchGit {
      inherit url;
      shallow = true;
    };

  apolloSkills = fetch "https://github.com/apollographql/skills";
  sotaSkills = fetch "https://github.com/martinholovsky/sota-skills";
  golangRepo = fetch "https://github.com/samber/cc-skills-golang";
  trailofbitsSkills = fetch "https://github.com/trailofbits/skills";

  # Curated subset of samber/cc-skills-golang (46 upstream). Every skill's
  # description is injected into each session's context, so keep this lean.
  golangSkills = [
    "golang-benchmark"
    "golang-code-style"
    "golang-concurrency"
    "golang-context"
    "golang-data-structures"
    "golang-design-patterns"
    "golang-error-handling"
    "golang-performance"
    "golang-project-layout"
    "golang-safety"
    "golang-security"
    "golang-testing"
  ];

  skills = {
    rust-best-practices = "${apolloSkills}/skills/rust-best-practices";
    sota-c-cpp = "${sotaSkills}/skills/sota-c-cpp";
    modern-python = "${trailofbitsSkills}/plugins/modern-python/skills/modern-python";
  }
  // lib.genAttrs golangSkills (name: "${golangRepo}/skills/${name}");
in
{
  home.file = lib.mapAttrs' (
    name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
  ) skills;

  # `npx skills add` previously installed real directories here; without this,
  # home-manager would back them up as .bak instead of replacing them.
  home.activation.agentSkillsCleanup = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    for s in ${lib.concatStringsSep " " (lib.attrNames skills)}; do
      p="$HOME/.agents/skills/$s"
      if [ -e "$p" ] && [ ! -L "$p" ]; then
        run rm -rf $VERBOSE_ARG "$p"
      fi
    done
  '';
}
