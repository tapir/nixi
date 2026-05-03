{ home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/amd.nix
    ../../modules/kernel-std.nix
    ../../modules/ugreen-dock.nix
    ../../modules/zbook-g1a.nix
    ../../modules/kmscon.nix
    ../../modules/containers.nix
  ];

  system.stateVersion = "26.05";
  home-manager.users.cosku = import ./home.nix;
  networking.hostName = "nixcosh-laptop";

  # Laptop specific flatpak packages
  services.flatpak = {
    packages = [
      "com.slack.Slack"
      "com.usebruno.Bruno"
    ];
  };
}
