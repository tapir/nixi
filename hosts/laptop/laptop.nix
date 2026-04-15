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

  boot.blacklistedKernelModules = [ "cdc_ether" ];
  boot.kernelModules = [ "r8152" ];

  # powerManagement.enable = true;
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
