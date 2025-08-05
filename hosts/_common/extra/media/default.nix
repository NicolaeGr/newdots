{
  lib,
  config,
  configLib,
  ...
}:
{
  imports = lib.flatten [
    (configLib.scanPaths ./.)
  ];

  options.extra.media.full = {
    enable = lib.mkEnableOption "Enable all media tools";
  };

  config = lib.mkIf config.extra.media.full.enable {
    extra.media.audio.enable = true;
    extra.media.video.enable = true;
    extra.media.connect.enable = true;
  };
}
