{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      nixupdate = "nix flake update && git pull && git commit -am \"nixpkg update\" && git push";
      devrun = "distrobox enter arch-dev";
    };
    initExtra = ''
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
    '';
  };
}
