{ ... }:

{
  dconf.settings = {
    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
    };
  };
}
