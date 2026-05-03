{ ... }:

{
  # Docker and podman setup
  virtualisation = {
    docker.enable = true;
    docker.daemon.settings.features.cdi = true;

    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

  # User settings
  users.users.cosku.extraGroups = [
    "docker"
    "podman"
  ];
}
