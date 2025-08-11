{
  pkgs,
  inputs,
  config,
  ...
}:
let
  mcManager = inputs.minecraft-manager.packages.${pkgs.system}.minecraft-app-manager;
in
{
  environment.systemPackages = [
    pkgs.openjdk17
    mcManager
  ];

  systemd.services.minecraft-manager = {
    description = "Minecraft App Manager Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    # user = "minecraft";
    # group = "minecraft";

    serviceConfig = {
      ExecStart = "${mcManager}/bin/minecraft-app-manager --workingPath /shared/minecraft";
      User = "minecraft";
      Group = "minecraft";
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      EnvironmentFile = config.sops.secrets."minecraft-env".path;
    };
  };

  users.users.minecraft = {
    isSystemUser = true;
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
