{
  options,
  config,
  lib,
  ...
}:
{

  options = {
    extra.hyprland.rofi.enable = lib.mkEnableOption {
      default = false;
      description = "Enable rofi";
    };
  };

  config = lib.mkIf config.extra.hyprland.rofi.enable {
    programs.rofi = {
      enable = true;
      # theme = builtins.readFile ./custom.rasi;
    };
  };
}
