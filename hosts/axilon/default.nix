# host no longer available, potentially to be reused in the future
{ configLib, lib, ... }:
{
  imports =
    [ ]
    ++ (map configLib.relativeToRoot [
      "hosts/_common/core"
      "hosts/_common/extra"
      "hosts/_common/users"
    ]);

  extra.gui.enable = true;
  extra.gui.hyprland.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
