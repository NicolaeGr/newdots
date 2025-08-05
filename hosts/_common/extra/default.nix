{
  config,
  configLib,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
in
{
  imports = lib.flatten [
    (configLib.scanPaths ./.)
  ];

  config = mkMerge [
    {
    }

    (mkIf config.extra.gui.enable {
      extra.hardware.audio.enable = true;
    })

    (mkIf config.extra.gaming.enable {
      extra.gaming.jc.enable = true;
    })
  ];
}
