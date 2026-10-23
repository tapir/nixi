{ ... }:

{
  # GNOME Remote Desktop server (RDP on :3389)
  services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];
  systemd.services.gnome-remote-desktop.wantedBy = [ "graphical.target" ];

  # Autologin keeps a GNOME session alive for GRD to mirror and unlocks the
  # login keyring, which is where `grd-ctl rdp set-credentials` stores the
  # RDP password -- without it the daemon can't read its credentials.
  services.displayManager.autoLogin = {
    enable = true;
    user = "cosku";
  };
}
