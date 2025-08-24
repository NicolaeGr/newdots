{ ... }:
{
  services.cloudflare-dyndns.domains = [ "drive.electrolit.biz" ];

  services.seafile = {
    enable = true;

    adminEmail = "nicolaegr@proton.me";
    initialAdminPassword = "init";

    ccnetSettings.General.SERVICE_URL = "https://drive.electrolit.biz";
  };
}
