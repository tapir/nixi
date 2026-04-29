{ ... }:
{
  xdg.configFile."autostart/io.github.focustimerhq.FocusTimer.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Focus Timer
    X-XDP-Autostart=io.github.focustimerhq.FocusTimer
    X-Flatpak=io.github.focustimerhq.FocusTimer
    Exec=/run/current-system/sw/bin/flatpak run --command=focus-timer io.github.focustimerhq.FocusTimer --gapplication-service
    X-GNOME-Autostart-enabled=true
  '';
}
