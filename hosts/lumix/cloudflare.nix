{
  configLib,
  config,
  pkgs,
  ...
}:
{
  sops.secrets."cloudflare_cred" = {
    sopsFile = (configLib.relativeToRoot "secrets/cloudflare_cred.json");
    key = "";
  };

  services.cloudflared = {
    enable = true;
    package = pkgs.unstable.cloudflared;
    tunnels = {
      "d816a0b5-9ded-43ef-af82-ccce79a7b919" = {
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
