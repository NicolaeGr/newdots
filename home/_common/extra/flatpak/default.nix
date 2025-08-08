{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  options = {
    extra.flatpak.enable = lib.mkEnableOption {
      default = false;
      description = "Enable the Flatpak package manager";
    };
  };

  config = lib.mkIf config.extra.flatpak.enable {
    home.packages = [ pkgs.flatpak ];

    services.flatpak = {
      enable = true;

      remotes = [
        {
          name = "nightly-gnome";
          location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
        }
      ];
      packages = [ "app.zen_browser.zen" ];

      overrides = {
        global = {
          Context = {
            filesystems = [
              "xdg-data/themes:ro"
              "xdg-data/icons:ro"
              "xdg-data/fonts:ro"
              "xdg-config/gtkrc:ro"
              "xdg-config/gtkrc-2.0:ro"
              "xdg-config/gtk-2.0:ro"
              "xdg-config/gtk-3.0:ro"
              "xdg-config/gtk-4.0:ro"
              "nix"
            ];
            sockets = [
              "wayland"
              "!x11"
              "!fallback-x11"
            ];
          };
        };
      };
    };
  };
}
