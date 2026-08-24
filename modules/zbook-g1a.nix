{ ... }:

{
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
}
