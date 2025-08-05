{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.extra.media.connect = {
    enable = lib.mkEnableOption "Enable media connect tools";
  };

  config = lib.mkIf config.extra.media.connect.enable {
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      jellyfin
    ];
  };
}
