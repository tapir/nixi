{ home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/packages.nix
    ../../modules/amd.nix
    ../../modules/kernel-std.nix
  ];

  networking.hostName = "nixcosh-laptop";

  #environment.systemPackages = with pkgs; [ ];

  home-manager.users.cosku = import ./home.nix;

  # services.scx = {
  #   enable = true;
  #   scheduler = "scx_bpfland";
  #   extraArgs = [
  #     "-s 20000"
  #     "-m powersave"
  #     "-I 100"
  #     "-t 100"
  #   ];
  # };

  services.flatpak = {
    packages = [
      "com.slack.Slack"
    ];
  };

  system.stateVersion = "26.05";
}
