{ config, pkgs, ... }:
{
  sops.secrets."cloudflared_cred" = { };
  sops.secrets."cloudflare_api_key" = { };

  services.cloudflared = {
    enable = true;
    package = pkgs.unstable.cloudflared;
    tunnels = {
      "8b63fee5-4681-49c5-bb56-1709c121d52a" = {
        credentialsFile = config.sops.secrets."cloudflared_cred".path;
        ingress = {
          "mc.electrolit.biz" = "tcp://localhost:25565";
          "*.electrolit.biz" = "http://localhost:80";
        };
        default = "http_status:404";
      };
    };
  };

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
