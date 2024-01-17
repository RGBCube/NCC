{ config, lib, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";
in serverSystemConfiguration {
  services.prometheus = {
    exporters.postfix = enabled {
      port = 9040;
    };

    scrapeConfigs = [{
      job_name = "postfix";

      static_configs = [{
        labels.job = "postfix";
        targets    = [
          "[::]:${toString config.services.prometheus.exporters.postfix.port}"
        ];
      }];
    }];
  };

  services.fail2ban.jails = {
    dovecot.settings = {
      filter   = "dovecot";
      maxretry = 3;
    };

    postfix.settings = {
      filter   = "postfix";
      maxretry = 3;
    };
  };

  services.kresd.listenPlain         = lib.mkForce [ "[::]:53" "0.0.0.0:53" ];
  services.redis.servers.rspamd.bind = "0.0.0.0";

  services.dovecot2.sieve = {
    extensions       = [ "fileinto" ];
    globalExtensions = [ "+vnd.dovecot.pipe" "+vnd.dovecot.environment" ];
    plugins          = [ "sieve_imapsieve" "sieve_extprograms" ];
  };

  mailserver = enabled {
    inherit fqdn;

    domains           = [ domain ];
    certificateScheme = "acme";

    hierarchySeparator = "/";
    useFsLayout        = true;

    mailDirectory  = "/var/lib/mail";
    sieveDirectory = "/var/lib/sieve";

    vmailUserName  = "mail";
    vmailGroupName = "mail";

    dmarcReporting = enabled {
      inherit domain;

      organizationName = "Doofemshmirtz Evil Inc.";
    };

    fullTextSearch = enabled {
      indexAttachments = true;
    };

    loginAccounts."contact@${domain}" = {
      aliases = [ "@${domain}" ];

      hashedPasswordFile = config.age.secrets."cube/password.hash.mail".path;
    };
  };
}
