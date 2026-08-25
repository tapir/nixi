{ ... }:

{
  xdg.configFile."pipewire/pipewire.conf.d/99-sink-hd599-eq.conf".source =
    ./99-sink-hd599-eq.conf;

  xdg.configFile."wireplumber/wireplumber.conf.d/99-default-sink.conf".source =
    ./99-default-sink.conf;
}
