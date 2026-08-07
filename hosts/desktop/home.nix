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
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      update-boot = "sudo nixos-rebuild boot --flake .#desktop";
      update-switch = "sudo nixos-rebuild switch --flake .#desktop";
      update-nixpkg = "nix flake update && git pull && git commit -am \"nixpkg update\" && git push";
    };
  };
}
