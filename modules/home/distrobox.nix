{ ... }:

{
  xdg.configFile."distrobox/distrobox.conf".text = ''
    container_manager="docker"
  '';
}
