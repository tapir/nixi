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
    ../../modules/home/hd599
    ../../modules/home/gnome.nix
    ../../modules/home/mangohud.nix
    ../../modules/home/distrobox.nix
    ../../modules/home/bash.nix
    ../../modules/home/pi
  ];

  programs.bash = {
    shellAliases = {
      nixboot = "cd $HOME/Documents/nixi && sudo nixos-rebuild boot --flake .#desktop && cd -";
      nixswitch = "cd $HOME/Documents/nixi && sudo nixos-rebuild switch --flake .#desktop && cd -";
      devreset = "docker pull ghcr.io/tapir/my-arch-dev:latest && yes | distrobox rm arch-dev && distrobox create --no-entry --name arch-dev --image ghcr.io/tapir/my-arch-dev:latest --additional-flags \"--device=nvidia.com/gpu=all\" --volume /run/opengl-driver:/run/opengl-driver --volume /run/opengl-driver-32:/run/opengl-driver-32";
    };
    initExtra = ''
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
      export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
      export ANDROID_HOME=$HOME/Android/Sdk
      export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
    '';
  };
}
