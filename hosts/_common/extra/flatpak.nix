{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  options = {
    extra.flatpak.enable = lib.mkEnableOption {
      description = "Enable Flatpak support";
      default = false;
    };
  };

  config = lib.mkIf config.extra.flatpak.enable {
    home-manager.sharedModules = [ ({ extra.flatpak.enable = true; }) ];

    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };

      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
        {
          name = "gnome-nightly";
          location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
        }
      ];

    };
  };
}
