{ ... }:

{
  xdg.configFile."crush/crushrc".text = ''
    #!/usr/bin/env bash

    mcp add godot --type stdio \
      --command npx \
      --args @tugcantopaloglu/godot-mcp \
      --env GODOT_PATH /usr/sbin/godot

    lsp add godot --command npx --args godot-lsp-bridge --filetypes gd
    lsp add go --command gopls
    lsp add clangd --command clangd
    lsp add typescript --command typescript-language-server --args --stdio

    hook add PreToolUse --matcher "^bash$" --command "rtk hook claude" --name rtk

    model large hyper/kimi-k3 --think --reasoning-effort max
    model small hyper/deepseek-v4-flash-0731 --reasoning-effort none
  '';
}
