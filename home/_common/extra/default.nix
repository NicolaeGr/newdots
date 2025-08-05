{ lib, configLib, ... }:
{
  imports = (configLib.scanPaths ./.);

  options.extra.gui.enable = lib.mkEnableOption {
    default = true;
    description = "Enable GUI features";
  };
}
