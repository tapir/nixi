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
    ../../modules/home/gnome.nix
    ../../modules/home/distrobox.nix
    ../../modules/home/bash.nix
    ../../modules/home/pi
  ];

  programs.bash = {
    shellAliases = {
      nixboot = "sudo nixos-rebuild boot --flake .#laptop";
      nixswitch = "sudo nixos-rebuild switch --flake .#laptop";
      devreset = "docker pull ghcr.io/tapir/my-arch-dev:latest && yes | distrobox rm arch-dev && distrobox create --no-entry --name arch-dev --image ghcr.io/tapir/my-arch-dev:latest --volume /run/opengl-driver:/run/opengl-driver --volume /run/opengl-driver-32:/run/opengl-driver-32";
    };
    initExtra = ''
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json
    '';
  };
}
