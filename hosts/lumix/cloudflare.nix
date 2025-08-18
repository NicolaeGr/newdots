{ config, pkgs, ... }:
{
  sops.secrets."cloudflare_api_key" = { };

  services.cloudflare-dyndns = {
    enable = true;

    apiTokenFile = config.sops.secrets."cloudflare_api_key".path;

    domains = [
      "electrolit.biz"
      "mc.electrolit.biz"
    ];
    frequency = "*:0/5"; # every 5 mins

    ipv4 = true;
    ipv6 = false;
    proxied = false;
    deleteMissing = false;
  };
}
