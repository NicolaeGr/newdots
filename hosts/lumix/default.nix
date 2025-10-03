{ configLib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    ./cloudflare.nix
    ./jellyfin.nix
    ./fast-ceiti.nix
    ./seafile.nix

    inputs.vscode-server.nixosModules.default

  ]
  ++ (map configLib.relativeToRoot [
    "hosts/_common/core"
    "hosts/_common/extra"
    "hosts/_common/users"
  ]);

  users.deploy.enable = true;
  users.victor.enable = true;

  # Nginx + Certbot
  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "nicolaegr@proton.me";
  };

  # Dell is not a bitch and supports linux driver
  services.fwupd.enable = true;

  services.croc.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.vscode-server.enable = true;
}
