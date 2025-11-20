{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.extra.hardware.audio = {
    enable = lib.mkEnableOption "Enable audio support";
  };

  config = lib.mkIf config.extra.hardware.audio.enable {
    security.rtkit.enable = true;

    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      playerctl
      pavucontrol
      carla
    ];
  };
}
