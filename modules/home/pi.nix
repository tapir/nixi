# pi coding agent — global configuration seeds
#
# IMPORTANT: pi mutates its own config files at runtime (`pi install`,
# /settings, model switching, curator provider changes...), so these files
# are NOT managed as read-only nix symlinks. Instead this module SEEDS them
# on activation when they don't exist yet (fresh machine / fresh home).
#
# To reset any file to the nix-managed version: delete the live file and
# re-run home-manager switch, e.g.:
#   rm ~/.config/pi/settings.json && nixswitch

{ config, pkgs, ... }:

let
  # ~/.config/pi/settings.json
  # Model/provider defaults, package manifest, subagent model tiering.
  # pi rewrites this file at runtime; the seed provides the initial state.
  settingsJson = pkgs.writeText "pi-settings.json" (
    builtins.toJSON {
      quietStartup = true;
      theme = "dark";
      defaultProvider = "openrouter";
      defaultModel = "qwen/qwen3.8-max";
      defaultThinkingLevel = "medium";

      packages = [
        "npm:pi-web-access"
        "npm:pi-subagents"
        "npm:pi-lens"
        "npm:@estebanforge/pi-codegraph-enhanced"
        "npm:@juicesharp/rpiv-ask-user-question"
        "npm:pi-rtk-optimizer"
        "npm:context-mode"
      ];

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

  # ~/.config/pi/web-search.json
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

  # ~/.config/pi/auth.json
  # API keys and OAuth tokens for providers.
  # Security Note: This puts the placeholder in the world-readable /nix/store.
  # Use agenix/sops-nix for real keys, or add them manually after deployment.
  authJson = pkgs.writeText "pi-auth.json" (
    builtins.toJSON {
      openrouter = {
        type = "api_key";
        key = "sk-or-v1-PLACEHOLDER";
      };
      # Example of other providers:
      # anthropic = { type = "api_key"; key = "sk-ant-PLACEHOLDER"; };
    }
  );

  # ~/.config/pi/AGENTS.md
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
    run mkdir $VERBOSE_ARG -p "$HOME/.config/pi/agent"

    # Keep a legacy symlink for any hardcoded extensions expecting ~/.pi
    run ln $VERBOSE_ARG -sfn "$HOME/.config/pi" "$HOME/.pi"

    if [ ! -e "$HOME/.config/pi/settings.json" ]; then
      run cp $VERBOSE_ARG ${settingsJson} "$HOME/.config/pi/settings.json"
      # Make it writable by the user so Pi can mutate it
      run chmod $VERBOSE_ARG 644 "$HOME/.config/pi/settings.json"
    fi

    if [ ! -e "$HOME/.config/pi/web-search.json" ]; then
      run cp $VERBOSE_ARG ${webSearchJson} "$HOME/.config/pi/web-search.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/web-search.json"
    fi

    if [ ! -e "$HOME/.config/pi/AGENTS.md" ]; then
      run cp $VERBOSE_ARG ${agentsMd} "$HOME/.config/pi/AGENTS.md"
      run chmod $VERBOSE_ARG 644 "$HOME/.config/pi/AGENTS.md"
    fi

    if [ ! -e "$HOME/.config/pi/auth.json" ]; then
      run cp $VERBOSE_ARG ${authJson} "$HOME/.config/pi/auth.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/auth.json"
    fi
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      export PI_CODING_AGENT_DIR="$HOME/.config/pi"
    '';
  };

  # Also setting sessionVariables is highly recommended so it applies
  # globally to non-bash sessions (like Wayland/X11 environments)
  home.sessionVariables = {
    PI_CODING_AGENT_DIR = "$HOME/.config/pi";
  };
}
