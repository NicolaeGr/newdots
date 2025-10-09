{ pkgs, config, ... }:
{
  sops.secrets = {
    "stalwart/mail-pw1" = { };
    "stalwart/mail-pw2" = { };
    "stalwart/admin-pw" = { };
    "stalwart/acme-secret" = { };
  };

  services.cloudflare-dyndns.domains = [ "mail.electrolit.biz" ];

  services.stalwart-mail = {
    enable = true;
    package = pkgs.stalwart-mail;
    openFirewall = true;

    settings = {
      server = {
        hostname = "mail.electrolit.biz";
        tls = {
          enable = true;
          implicit = true;
        };

        listener = {
          smtp = {
            protocol = "smtp";
            bind = "[::]:25";
          };
          submissions = {
            bind = "[::]:465";
            protocol = "smtp";
          };
          imaps = {
            bind = "[::]:993";
            protocol = "imap";
          };
          jmap = {
            bind = "[::]:9091";
            url = "https://mail.electrolit.biz";
            protocol = "jmap";
          };
          management = {
            bind = [ "127.0.0.1:9090" ];
            protocol = "http";
          };
        };
      };

      lookup.default = {
        hostname = "mail.electrolit.biz";
        domain = "electrolit.biz";
      };

      ############################################
      ## ACME / LETSENCRYPT
      ############################################
      acme."letsencrypt" = {
        directory = "https://acme-v02.api.letsencrypt.org/directory";
        challenge = "dns-01";
        contact = "admin@electrolit.biz";
        domains = [
          "electrolit.biz"
          "mail.electrolit.biz"
        ];
        provider = "cloudflare";
        secret = "%{file:${config.sops.secrets."stalwart/acme-secret".path}}%";
      };

      session.auth = {
        mechanisms = "[plain]";
        directory = "'in-memory'";
      };

      storage.directory = "in-memory";
      session.rcpt.directory = "'in-memory'";
      queue.outbound.next-hop = "'local'";

      directory."imap".lookup.domains = [ "electrolit.biz" ];

      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "User 1";
            secret = "%{file:${config.sops.secrets."stalwart/mail-pw1".path}}%";
            email = [ "user1@electrolit.biz" ];
          }
          {
            class = "individual";
            name = "postmaster";
            secret = "%{file:${config.sops.secrets."stalwart/mail-pw2".path}}%";
            email = [ "postmaster@electrolit.biz" ];
          }
        ];
      };

      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:${config.sops.secrets."stalwart/admin-pw".path}}%";
      };

    };
  };

  services.nginx.virtualHosts."mail.electrolit.biz" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
    };
    serverAliases = [
      "mta-sts.electrolit.biz"
      "autoconfig.electrolit.biz"
      "autodiscover.electrolit.biz"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    25
    465
    993
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [
    80
    443
  ];
}
