{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-user-dirs
  ];

  xdg = {
    #   mime = {
    #     enable = true;
    #     defaultApplications = {
    #       "text/plain" = [ "codium.desktop" ];
    #       "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    #     };
    #   };
  };
}
