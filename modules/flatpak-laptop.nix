{ ... }:

{
    services.flatpak = {
        enable = true;
        packages = [
            "org.mozilla.firefox"
        ];
    };
}