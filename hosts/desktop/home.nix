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
    ../../modules/home/crush.nix
    ../../modules/home/distrobox.nix
    ../../modules/home/bash.nix
  ];
}
