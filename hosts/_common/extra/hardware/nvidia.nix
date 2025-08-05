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
    environment.sessionVariables = {
      WLD_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      inputs.envycontrol.packages.x86_64-linux.default
      nvtopPackages.full

      glmark2
      glxinfo
    ];
  };
}
