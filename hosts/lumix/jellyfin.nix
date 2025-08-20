{ ... }:
{
  config = {
    services.cloudflare-dyndns.domains = [ "jf.electrolit.biz" ];

    services.jellyfin = {
      enable = true;
      openFirewall = true;

      dataDir = "/storage/jellyfin";
    };

    services.nginx = {
      virtualHosts."jf.electrolit.biz" = {
        addSSL = true;
        enableACME = true;

        extraConfig = ''

          client_max_body_size 20M;

          # Security / XSS Mitigation
          add_header X-Content-Type-Options "nosniff" always;

          # Permissions-Policy (reduce fingerprinting)
          add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;

          # Content Security Policy
          add_header Content-Security-Policy "default-src https: data: blob:; img-src 'self' https://*; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'; font-src 'self';" always;

          # Proxy settings
          set $jellyfin 127.0.0.1;

          location / {
            proxy_pass http://$jellyfin:8096;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_buffering off;
          }

          location /socket {
            proxy_pass http://$jellyfin:8096;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          }

          # access_log /var/log/nginx/access.log stripsecrets;
        '';
      };
    };
  };
}
