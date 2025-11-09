{ config, ... }:
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/.desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Media/audio";
      pictures = "${config.home.homeDirectory}/Media/images";
      videos = "${config.home.homeDirectory}/Media/video";

      extraConfig = {
        XDG_PUBLICSHARE_DIR = "/var/empty";
        XDG_TEMPLATES_DIR = "/var/empty";
      };
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
    };
    configFile."mimeapps.list".force = true;

    systemDirs = {
      data = [
        "/usr/share"
        "/usr/local/share"
        "/var/lib/flatpak/exports/share/applications"
      ];
    };
  };
}
