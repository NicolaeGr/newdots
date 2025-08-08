{ configLib, ... }:
{
  imports =
    [ ]
    ++ (map configLib.relativeToRoot [
      "hosts/_common/core"
      "hosts/_common/extra"
      "hosts/_common/users"
    ]);

  services.croc.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
