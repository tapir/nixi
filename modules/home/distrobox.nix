{ ... }:

{
  xdg.configFile."distrobox/distrobox.conf".text = ''
    container_manager="docker"
  '';

  home.sessionVariables = {
    DISTROBOX_CONTAINER_MANAGER = "docker";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      devrun = "distrobox enter arch-dev";
      containerclean = "docker system prune -a --volumes && podman system prune -a --volumes";
    };
  };
}
