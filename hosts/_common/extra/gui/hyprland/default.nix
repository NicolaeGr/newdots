{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    extra.gui.hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf config.extra.gui.hyprland.enable {
    home-manager.sharedModules = [ ({ extra.hyprland.enable = true; }) ];

    services.displayManager = {
      sessionPackages = with pkgs; [ hyprland ];
      sddm.settings = {
        General = {
          DefaultSession = "hyprland.desktop";
        };
      };
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.gdm.enableGnomeKeyring = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
