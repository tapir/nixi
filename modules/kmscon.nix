{ pkgs, ... }:

{
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    fonts = [
      {
        name = "Iosevka Extended";
        package = pkgs.iosevka;
      }
    ];
  };
}
