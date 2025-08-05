{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [ ./hyprland ];

  options = {
    extra.gui.enable = lib.mkEnableOption "Enable GUI tools";
  };

  config = lib.mkIf config.extra.gui.enable {
    home-manager.sharedModules = [ ({ extra.gui.enable = true; }) ];

    services.libinput.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config = {
        common = {
          default = [ "gtk" ];
        };
      };
    };

    security.polkit.enable = true;

    services.displayManager = {
      enable = true;
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };
  };
}
