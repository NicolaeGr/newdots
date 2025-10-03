{ configLib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    ./cloudflare.nix
    ./jellyfin.nix
    ./fast-ceiti.nix
    ./seafile.nix
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

  environment.systemPackages = with pkgs; [

    vscode
    vscode.fhs
    (vscode-with-extensions.override {
      vscodeExtensions =
        with vscode-extensions;
        [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.87.0";
            sha256 = "1qqsnzn9z11jr72n7cl0ab6i9mv49c0ijcp699zbglv5092gmrf9";
          }
        ];
    })
  ];
}
