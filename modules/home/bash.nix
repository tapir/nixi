{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      nixupdate = "git pull && nix flake update && git commit -am \"nixpkg update\" && git push";
      devrun = "distrobox enter arch-dev";
      containerclean = "docker system prune -a --volumes && podman system prune -a --volumes";
    };
  };
}
