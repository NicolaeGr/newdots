{ lib
, config
, configLib
, pkgs
, ...
}: {
  imports = lib.flatten [
    (configLib.scanPaths ./.)
  ];

  options = {
    extra.common.enable = lib.mkEnableOption {
      default = false;
      description = "Enable common extra packages";
    };
  };

  config = lib.mkIf config.extra.common.enable {
    environment.systemPackages = with pkgs;  [
      discord
      telegram-desktop
    ];
  };
}
