{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      nixupdate = "nix flake update && git pull && git commit -am \"nixpkg update\" && git push";
      devrun = "distrobox enter arch-dev";
    };
  };
}
