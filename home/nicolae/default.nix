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
    home.packages = [ pkgs.firefox ];
    # extra.flatpak.enable = true;

    # services.flatpak.packages =
    #   [ "com.gitlab.tipp10.tipp10" "app.zen_browser.zen" ];
  };
}
