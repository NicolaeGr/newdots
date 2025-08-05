{ lib, configLib, ... }: {
  imports = lib.flatten [
    (configLib.scanPaths ./.)
  ];
}
