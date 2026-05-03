{ pkgs, ... }:

{
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    fonts = [
      {
        name = "Iosevka";
        package = pkgs.iosevka;
      }
    ];
  };
}
