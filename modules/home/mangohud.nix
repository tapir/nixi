{ ... }:

{
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      fps_metrics = "avg,0.01";
      cpu_stats = true;
      gpu_stats = true;
      cpu_load_change = true;
      gpu_load_change = true;
    };
  };
}
