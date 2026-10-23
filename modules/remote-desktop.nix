{ config, lib, pkgs, ... }:

let
  stateDir = "/var/lib/gnome-remote-desktop";
  grdctl = "${pkgs.gnome-remote-desktop}/bin/grdctl";
in
{
  # GNOME Remote Desktop, system/headless mode: RDP on :3389, shows the GDM
  # greeter before login and hands over to the desktop session after.
  services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # GRD seals its RDP credentials in the TPM; without this /dev/tpmrm0 stays
  # root-only and the daemon silently falls back to a plaintext GKeyFile.
  security.tpm2.enable = true;
  users.users.gnome-remote-desktop.extraGroups = [ "tss" ];

  # The NixOS module only runs the daemon; all system-mode configuration is
  # mutable state with no NixOS options, so apply it idempotently at boot.
  # The RDP password is the exception (secret): set it once per machine with
  #   sudo grdctl --system rdp set-credentials <user> <password>
  # It persists TPM-sealed across rebuilds and reboots.
  systemd.services.gnome-remote-desktop-setup = {
    wantedBy = [ "multi-user.target" ];
    after = [ "dbus.service" ];
    requires = [ "dbus.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      if [ ! -f ${stateDir}/tls.crt ]; then
        ${pkgs.openssl}/bin/openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
          -subj "/CN=${config.networking.hostName}" \
          -keyout ${stateDir}/tls.key -out ${stateDir}/tls.crt
        chown root:gnome-remote-desktop ${stateDir}/tls.key ${stateDir}/tls.crt
        chmod 640 ${stateDir}/tls.key ${stateDir}/tls.crt
      fi
      ${grdctl} --system rdp set-tls-key ${stateDir}/tls.key
      ${grdctl} --system rdp set-tls-cert ${stateDir}/tls.crt
      ${grdctl} --system rdp enable
      ${grdctl} --system rdp disable-view-only
      ${config.systemd.package}/bin/systemctl try-restart gnome-remote-desktop.service
    '';
    # grdctl --system spawns its configuration helper via pkexec
    environment = {
      PATH = lib.mkForce "${pkgs.polkit}/bin:${pkgs.coreutils}/bin";
      DBUS_SYSTEM_BUS_ADDRESS = "unix:path=/run/dbus/system_bus_socket";
    };
  };
}
