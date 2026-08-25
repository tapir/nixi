{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      nixupdate = "cd $HOME/Documents/nixi && git pull && nix flake update && git commit -am \"nixpkg update\" && git push && cd -";
      devrun = "distrobox enter arch-dev";
      containerclean = "docker system prune -a --volumes && podman system prune -a --volumes";
    };
  };
}
