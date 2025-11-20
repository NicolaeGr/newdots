{ configLib, pkgs, ... }:
{
  imports = [
    ./config
  ]
  ++ (map configLib.relativeToRoot [
    "home/_common/core"
    "home/_common/extra"
  ]);

  config = {
    home.packages = [
      pkgs.firefox
    ];

    extra.dev.enable = true;

    services.flatpak.packages = [ "com.gitlab.tipp10.tipp10" ];
  };
}
