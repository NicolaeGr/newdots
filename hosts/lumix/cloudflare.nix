{ config, pkgs, ... }:
{
  sops.secrets."cloudflare_cred" = { };

  services.cloudflared = {
    enable = true;
    package = pkgs.unstable.cloudflared;
    tunnels = {
      "8b63fee5-4681-49c5-bb56-1709c121d52a" = {
        credentialsFile = config.sops.secrets."cloudflare_cred".path;
        ingress = {
          "mc.electrolit.biz" = "http://localhost:25565";
          "*.electrolit.biz" = "http://localhost:80";
        };
        default = "http_status:404";
      };
    };
  };

}
