{ pkgs, ... }:

{
  boot = {
    # More performance oriented kernel with schedext enabled.
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };
}
