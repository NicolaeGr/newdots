{ configLib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ (map configLib.relativeToRoot [
    "hosts/_common/core"
    "hosts/_common/extra"
    "hosts/_common/users"
  ]);

  # Dell is not a bitch and supports linux driver
  services.fwupd.enable = true;

  services.croc.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
