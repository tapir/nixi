{ ... }:

{
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    legacy_layout=0
    horizontal
    gpu_stats
    cpu_stats
    cpu_power
    gpu_power
    ram
    fps
    fps_metrics=avg,0.01
    frametime=0
    hud_no_margin
    table_columns=14
    frame_timing=1
  '';
}
