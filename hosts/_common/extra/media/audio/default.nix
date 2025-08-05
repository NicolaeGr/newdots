{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  options.extra.media.audio = {
    enable = lib.mkEnableOption "Enable media audio tools";
  };

  config = lib.mkIf config.extra.media.audio.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];
  };
}
