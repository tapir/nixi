{ config, pkgs, ... }:

{
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      devrun = "distrobox enter arch-dev";
      containerclean = "docker system prune -a --volumes && podman system prune -a --volumes";
    };

    # Function instead of alias: handles "nothing to commit" without
    # aborting the chain (which would skip git push and strand you in nixi).
    initExtra = ''
      nixupdate() {
        cd "$HOME/Documents/nixi" || return 1
        git pull || return 1
        nix flake update || return 1
        git add -A
        if ! git diff --cached --quiet; then
          git commit -m "nixpkg update" || return 1
        fi
        git push || return 1
        cd -
      }
    '';
  };
}
