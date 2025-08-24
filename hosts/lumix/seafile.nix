{ pkgs, ... }:
{
  services.cloudflare-dyndns.domains = [ "drive.electrolit.biz" ];

  services.nginx = {
    commonHttpConfig = ''
      log_format seafileformat '$http_x_forwarded_for $remote_addr [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" $upstream_response_time';
    '';

    virtualHosts."drive.electrolit.biz" = {
      forceSSL = true;
      enableACME = true;

      locations = {
        "/" = {
          proxyPass = "http://unix:/run/seahub/gunicorn.sock";
          extraConfig = ''
            proxy_set_header   Host $host;
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host $server_name;
            proxy_read_timeout  1200s;
            client_max_body_size 0;
          '';
        };
        "/seafhttp" = {
          proxyPass = "http://unix:/run/seafile/server.sock";
          extraConfig = ''
            rewrite ^/seafhttp(.*)$ $1 break;
            client_max_body_size 0;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_connect_timeout  36000s;
            proxy_read_timeout  36000s;
            proxy_send_timeout  36000s;
            send_timeout  36000s;
          '';
        };
      };

      extraConfig = ''
        proxy_set_header X-Forwarded-For $remote_addr;
      '';
    };
  };

  environment.systemPackages = with pkgs.unstable; [ seafile-server ];

  services.seafile = {
    enable = true;

    adminEmail = "nicolaegr@proton.me";
    initialAdminPassword = "init";

    ccnetSettings.General.SERVICE_URL = "https://drive.electrolit.biz";

    seafileSettings = {
      fileserver = {
        host = "unix:/run/seafile/server.sock";
      };
    };
  };
}
