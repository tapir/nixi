{ pkgs, ... }:
{
  # Rename USB ethernet to a stable name based on MAC
  systemd.network.links."10-usbeth" = {
    matchConfig.MACAddress = "6c:1f:f7:75:07:ae";
    linkConfig.Name = "usbeth0";
  };

  # Apply ethtool tuning whenever the device appears
  systemd.services."ethtool-tune-usbeth0" = {
    description = "Disable EEE and offloads on USB ethernet";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-subsystem-net-devices-usbeth0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-usbeth0.device" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.ethtool}/bin/ethtool --set-eee usbeth0 eee off"
        "${pkgs.ethtool}/bin/ethtool -K usbeth0 tso off gso off gro off"
      ];
    };
  };
}
