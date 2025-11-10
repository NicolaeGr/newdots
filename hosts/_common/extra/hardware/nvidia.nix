{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.extra.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable NVIDIA support";
  };

  config = lib.mkIf config.extra.hardware.nvidia.enable {
    environment.systemPackages = with pkgs; [
      nvtopPackages.full

      glmark2
      glxinfo
    ];
  };
}
