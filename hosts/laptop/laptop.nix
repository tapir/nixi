{ home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/packages.nix
    ../../modules/amd.nix
    ../../modules/kernel-std.nix
    ../../modules/ugreen-dock.nix
  ];

  system.stateVersion = "26.05";

  home-manager.users.cosku = import ./home.nix;

  networking.hostName = "nixcosh-laptop";

  powerManagement.enable = true;

  boot.kernelParams = [
    "amd_iommu=off"
  ];

  services.logind.settings.Login = {
    SleepOperation = "suspend";
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "ignore";
    HandleRebootKey = "suspend";
    HandleRebootKeyLongPress = "ignore";
    HandleSuspendKey = "suspend";
    HandleSuspendKeyLongPress = "ignore";
    HandleHibernateKey = "suspend";
    HandleHibernateKeyLongPress = "ignore";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "suspend";
    PowerKeyIgnoreInhibited = "yes";
    SuspendKeyIgnoreInhibited = "yes";
    HibernateKeyIgnoreInhibited = "yes";
    LidSwitchIgnoreInhibited = "yes";
    RebootKeyIgnoreInhibited = "yes";
  };

  services.upower = {
    enable = true;
    ignoreLid = true;
    allowRiskyCriticalPowerAction = true;
    criticalPowerAction = "Suspend";
  };

  services.flatpak = {
    packages = [
      "com.slack.Slack"
      "com.usebruno.Bruno"
    ];
  };
}
