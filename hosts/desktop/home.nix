{
  config,
  nixosConfig,
  ...
}:
{
  home.username = "cosku";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = nixosConfig.system.stateVersion;

  imports = [
    ../../modules/home/fonts.nix
    ../../modules/home/gtk3.nix
    ../../modules/home/hd599.nix
    ../../modules/home/gnome.nix
    ../../modules/home/mangohud.nix
    ../../modules/home/distrobox.nix
    ../../modules/home/bash.nix
    ../../modules/home/pi.nix
  ];

  programs.bash = {
    shellAliases = {
      nixboot = "sudo nixos-rebuild boot --flake .#desktop";
      nixswitch = "sudo nixos-rebuild switch --flake .#desktop";
      devreset = "docker pull ghcr.io/tapir/my-arch-dev:latest && yes | distrobox rm arch-dev && distrobox create --no-entry --name arch-dev --image ghcr.io/tapir/my-arch-dev:latest --additional-flags \"--device=nvidia.com/gpu=all\" --volume /run/opengl-driver:/run/opengl-driver --volume /run/opengl-driver-32:/run/opengl-driver-32";
    };
    initExtra = ''
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
    '';
  };
}
