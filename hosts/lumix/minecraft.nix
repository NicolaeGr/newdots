{ pkgs, inputs, ... }:
let
  mcManager = inputs.minecraft-manager.packages.${pkgs.system}.minecraft-app-manager;
in
{
  environment.systemPackages = [
    pkgs.openjdk-17-jre
    mcManager
  ];

  # systemd.services.minecraft-manager = {
  #   description = "Minecraft App Manager Service";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];

  #   execStart = "${mcManager}/bin/minecraft-app-manager";

  #   user = "minecraft";
  #   group = "minecraft";

  #   serviceConfig = {
  #     Type = "simple";
  #     Restart = "always";
  #     RestartSec = 5;
  #   };
  # };

  users.users.minecraft = {
    isSystemUser = true;
    isDisabled = true;
    group = "minecraft";
    shell = "/bin/false";
    createHome = false;
  };
  users.groups.minecraft = { };

  # systemd.services.minecraft-manager.postStart = ''
  #   mkdir -p /var/lib/minecraft-manager
  #   chown minecraft:minecraft /var/lib/minecraft-manager
  # '';
}
