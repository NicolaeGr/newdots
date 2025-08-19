{ ... }:
{
  config = {
    services.plex = {

      enable = true;
      openFirewall = true;

      dataDir = "/storage/plex";
    };
  };
}
