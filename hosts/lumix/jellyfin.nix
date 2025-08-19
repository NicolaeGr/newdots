{ ... }:
{
  config = {
    services.jellyfin = {
      enable = true;
      openFirewall = true;

      dataDir = "/storage/jellyfin";
    };
  };
}
