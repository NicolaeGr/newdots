{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    extra.flatpak.enable = lib.mkEnableOption {
      description = "Enable Flatpak support";
      default = false;
    };
  };

  config = lib.mkIf config.extra.flatpak.enable {
    home-manager.sharedModules = [ ({ extra.flatpak.enable = true; }) ];

    services.flatpak.enable = true;
  };
}
