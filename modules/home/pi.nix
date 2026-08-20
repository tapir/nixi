# pi coding agent — global configuration seeds
#
# IMPORTANT: pi mutates its own config files at runtime (`pi install`,
# /settings, model switching, curator provider changes...), so these files
# are NOT managed as read-only nix symlinks. Instead this module SEEDS them
# on activation when they don't exist yet (fresh machine / fresh home).
#
# To reset any file to the nix-managed version: delete the live file and
# re-run home-manager switch, e.g.:
#   rm ~/.pi/agent/settings.json && nixswitch
#
# NOTE: webSearchConfig below contains API keys in plain text. They are
# stored with 600 permissions, but they also live in the nix store (and in
# this repo if it is committed). Rotate them if that's a concern, or move
# them behind agenix/home-sops.

{ ... }:

let
  # ~/.pi/agent/settings.json
  # Model/provider defaults, package manifest, subagent model tiering.
  # pi rewrites this file at runtime; the seed provides the initial state.
  settingsJson = pkgs.writeText "pi-settings.json" (
    builtins.toJSON {
      quietStartup = true;
      theme = "dark";
      defaultProvider = "openrouter";
      defaultModel = "qwen/qwen3.8-max";
      defaultThinkingLevel = "medium";

      # Package manifest — pi installs missing entries automatically
      # (also restorable explicitly with: pi update --extensions)
      packages = [
        "npm:pi-web-access"
        "npm:pi-subagents"
        "npm:pi-lens"
        "npm:@estebanforge/pi-codegraph-enhanced"
        "npm:@juicesharp/rpiv-ask-user-question"
        "npm:pi-rtk-optimizer"
        "npm:context-mode"
      ];

      # Subagent model tiering (main agent inherits defaults above)
      subagents.agentOverrides = {
        scout = {
          model = "qwen/qwen3.8-max";
          thinking = "low";
        };
        researcher = {
          model = "qwen/qwen3.8-max";
          thinking = "medium";
        };
        worker = {
          model = "moonshotai/kimi-k3";
          thinking = "high";
        };
        reviewer = {
          model = "qwen/qwen3.8-max";
          thinking = "high";
        };
        oracle = {
          model = "qwen/qwen3.8-max";
          thinking = "max";
        };
      };
    }
  );

  # ~/.pi/web-search.json — pi-web-access providers: Exa primary, Kagi fallback
  webSearchJson = pkgs.writeText "pi-web-search.json" (
    builtins.toJSON {
      exaApiKey = "EXA_API_KEY";
      kagiApiKey = "KAGI_API_KEY";
      searchRouting = {
        providers = [
          "exa"
          "kagi"
        ];
        fallbackOn = [
          "transient"
          "quota"
          "network"
          "invalid-response"
        ];
      };
    }
  );

  # ~/.pi/agent/AGENTS.md — global agent instructions, loaded into every session
  agentsMd = pkgs.writeText "pi-AGENTS.md" ''
    # Global Instructions

    ## Delegation (pi-subagents)
    - Before planning work in an unfamiliar codebase, delegate to `scout` for recon.
    - Before trusting external facts (docs, APIs, versions, news), delegate to `researcher` or use `web_search` for quick lookups.
    - For well-scoped implementation tasks, delegate to `worker`.
    - Architecture phase: gather context with `scout`, draft the design, then consult `oracle` to stress-test it (hidden assumptions, conflicts with existing decisions, tradeoffs). Use follow-up consultation rounds for material tradeoffs. Only proceed to implementation after oracle concerns are addressed.
    - After finishing an implementation, run `reviewer` on the changes before summarizing.
    - Keep quick one-off chores in the main session; delegate when the work would clutter context or benefits from a fresh perspective.

    ## Web research (pi-web-access)
    - Use `web_search` for quick factual lookups; prefer the `researcher` subagent for multi-source research that needs a brief with citations.
  '';
in
{
  # Seed pi config files only when absent; live files belong to pi/the user.
  home.activation.piSeedConfigs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir $VERBOSE_ARG -p "$HOME/.pi/agent"

    if [ ! -e "$HOME/.pi/agent/settings.json" ]; then
      run cp $VERBOSE_ARG ${settingsJson} "$HOME/.pi/agent/settings.json"
    fi

    if [ ! -e "$HOME/.pi/web-search.json" ]; then
      run cp $VERBOSE_ARG ${webSearchJson} "$HOME/.pi/web-search.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.pi/web-search.json"
    fi

    if [ ! -e "$HOME/.pi/agent/AGENTS.md" ]; then
      run cp $VERBOSE_ARG ${agentsMd} "$HOME/.pi/agent/AGENTS.md"
    fi
  '';
}
