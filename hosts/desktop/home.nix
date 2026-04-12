{ config, nixosConfig, ... }:
{
  home.username = "cosku";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = nixosConfig.system.stateVersion;

  xdg.configFile."pipewire/pipewire.conf.d/99-sink-hd599-eq.conf".source =
    ./files/99-sink-hd599-eq.conf;

  xdg.configFile."wireplumber/wireplumber.conf.d/99-default-sink.conf".source =
    ./files/99-default-sink.conf;

  imports = [
    ../../modules/home/fonts.nix
  ];
}
