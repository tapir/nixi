{
  config,
  nixosConfig,
  pkgs,
  ...
}:
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

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
  };
}
