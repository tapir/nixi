{ ... }:

{
  xdg.configFile."crush/crushrc".text = ''
    #!/usr/bin/env bash

    mcp add godot --type stdio \
      --command npx \
      --args @tugcantopaloglu/godot-mcp \
      --env GODOT_PATH /usr/sbin/godot

    lsp add godot \
      --command npx \
      --args godot-lsp-bridge \
      --filetypes gd

    hook add PreToolUse --matcher "^bash$" --command "rtk hook claude" --name rtk
  '';
}
