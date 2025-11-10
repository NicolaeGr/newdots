{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.extra.work = {
    enable = lib.mkEnableOption "Work configuration";
  };

  config = lib.mkIf config.extra.work.enable {
    environment.systemPackages = with pkgs; [

    ];
  };

}
