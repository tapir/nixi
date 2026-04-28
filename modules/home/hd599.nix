{ ... }:

{
  xdg.configFile."pipewire/pipewire.conf.d/99-sink-hd599-eq.conf".source =
    ./hd599/99-sink-hd599-eq.conf;

  xdg.configFile."wireplumber/wireplumber.conf.d/99-default-sink.conf".source =
    ./hd599/99-default-sink.conf;
}
