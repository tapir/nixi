{ config, lib, pkgs, ... }:

let
  stateDir = "/var/lib/gnome-remote-desktop";
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

  # `grdctl --system rdp enable` cannot work on NixOS: it runs `systemctl
  # enable` first, which fails against the read-only /etc/systemd/system and
  # aborts before setting the flag. The daemon reads this key file directly
  # (and file-monitors it), so declare it instead. The RDP password is the
  # exception (secret, TPM-sealed): set it once per machine with
  #   sudo grdctl --system rdp set-credentials <user> <password>
  environment.etc."gnome-remote-desktop/grd.conf".text = ''
    [RDP]
    enabled=true
    tls-key=${stateDir}/tls.key
    tls-cert=${stateDir}/tls.crt
  '';

  # The self-signed TLS cert is mutable per-machine state; generate it once.
  systemd.services.gnome-remote-desktop-setup = {
    wantedBy = [ "multi-user.target" ];
    # The daemon's StateDirectory creates ${stateDir}; the daemon starts
    # without a cert, waits, and is restarted here once the cert exists.
    after = [ "gnome-remote-desktop.service" ];
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
      ${config.systemd.package}/bin/systemctl try-restart gnome-remote-desktop.service
    '';
    environment.PATH = lib.mkForce "${pkgs.coreutils}/bin";
  };
}
