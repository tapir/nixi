{ ... }:

{
  # Scheduler for game performance
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
    extraArgs = [
      "-m performance"
      "-w"
    ];
  };
}
