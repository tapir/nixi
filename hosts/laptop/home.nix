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
    ../../modules/home/crush.nix
    ../../modules/home/distrobox.nix
    ../../modules/home/bash.nix
  ];

  programs.bash = {
    shellAliases = {
      nixboot = "sudo nixos-rebuild boot --flake .#laptop";
      nixswitch = "sudo nixos-rebuild switch --flake .#laptop";
    };
  };
}
