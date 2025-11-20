{
  pkgs,
  config,
  options,
  lib,
  ...
}:
{

  options = {
    extra.hardware.backlight.enable = lib.mkEnableOption {
      default = false;
      description = "Enable backlight control";
    };
  };

  config = lib.mkIf config.extra.hardware.backlight.enable {
    environment.systemPackages = with pkgs; [
      xorg.xbacklight
    ];

    programs.light.enable = true;
    security.sudo.extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            options = [ "NOPASSWD" ];
            command = "${pkgs.light}/bin/light";
          }
        ];
      }
    ];
  };
}
