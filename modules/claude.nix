{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.claude-desktop.overlays.default ];
  environment.systemPackages = [ pkgs.claude-desktop-fhs ];
}
