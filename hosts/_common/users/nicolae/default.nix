{
  pkgs,
  config,
  lib,
  configLib,
  ...
}:
let
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{
  options = {
    users.nicolae.enable = lib.mkEnableOption {
      default = false;
      description = "Enable Nicolae's user configuration.";
    };
  };

  config = lib.mkIf config.users.nicolae.enable {
    users.users.nicolae = {
      isNormalUser = true;
      home = "/home/nicolae";
      description = "Nicolae";

      initialPassword = "test";
      hashedPasswordFile = config.sops.secrets."passwords/nicolae".path;
      packages = [ pkgs.home-manager ];

      extraGroups = [
        "wheel"
      ]
      ++ configLib.ifUserGroupExists [
        "networkmanager"
        "audio"
        "video"
        "render"
        "input"
        "storage"
        "users"
        "power"
        "libvirt"
        "docker"
        "adbusers"
        "vboxusers"
      ] config;

      openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);
    };

    home-manager.users.nicolae.imports = [
      {
        home = {
          username = "nicolae";
          homeDirectory = "/home/nicolae";
        };
      }
      (configLib.relativeToRoot "home/nicolae/default.nix")
    ];
  };
}
