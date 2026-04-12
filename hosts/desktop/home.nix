{ config, ... }: {
    home.username = "cosku";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = config.system.stateVersion;

    imports = [
        ../../modules/home/fonts.nix
    ];
}