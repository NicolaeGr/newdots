{ lib, config, ... }:
{

  options = {
    extra.hyprland.swww.enable = lib.mkEnableOption {
      default = false;
      description = "Enable swww";
    };
  };

  config = lib.mkIf config.extra.hyprland.swww.enable {
    home.file."bg.jpg" = {
      target = ".config/hypr/backgrounds/bg.jpg";
      source = ./bg.jpg;
    };

    services.swww.enable = true;

    wayland.windowManager.hyprland.settings.exec-once = [
      "swww init"
      "swww img ${config.home.homeDirectory}/.config/hypr/backgrounds/bg.jpg"
    ];
  };
}
