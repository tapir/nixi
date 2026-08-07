{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      nixupdate = "nix flake update && git pull && git commit -am \"nixpkg update\" && git push";
      devrun = "distrobox enter arch-dev";
      devreset = "docker pull ghcr.io/tapir/my-arch-dev:latest && yes | distrobox rm arch-dev && distrobox create --name arch-dev --image ghcr.io/tapir/my-arch-dev:latest --additional-flags \"--device=nvidia.com/gpu=all\" --volume /run/opengl-driver:/run/opengl-driver --volume /run/opengl-driver-32:/run/opengl-driver-32";
    };
    initExtra = ''
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
    '';
  };
}
