{ config, lib, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";
in serverSystemConfiguration {
  age.secrets."cube.mail.password.dmarc" = {
    owner = "dmarc-exporter";
    group = "dmarc-exporter";
  };

  services.prometheus.exporters = {
    dmarc = enabled {
      imap.host         = domain;
      imap.passwordFile = config.age.secrets."cube.mail.password.dmarc".path;
      imap.username     = "contact@${domain}";

      listenAddress = "::";
      port          = 9020;
    };

    dovecot = enabled {
      port       = 9021;
      socketPath = "/var/run/dovecot2/old-stats";
      user       = "root";
    };

    postfix = enabled {
      port = 9022;
    };

    rspamd  = enabled {
      port = 9023;
    };
  };

  services.prometheus.scrapeConfigs = [{
    job_name = "mail";

    static_configs = [{
      labels.job = "mail";
      targets    = [
        "[::]:${toString config.services.prometheus.exporters.dmarc.port}"
        "[::]:${toString config.services.prometheus.exporters.dovecot.port}"
        "[::]:${toString config.services.prometheus.exporters.postfix.port}"
        "[::]:${toString config.services.prometheus.exporters.rspamd.port}"
      ];
    }];
  }];

  services.kresd.listenPlain         = lib.mkForce [ "[::]:53" "0.0.0.0:53" ];
  services.redis.servers.rspamd.bind = "0.0.0.0";

  mailserver = enabled {
    inherit fqdn;

    domains = [ domain ];

    certificateScheme = "acme";

    hierarchySeparator = "/";
    useFsLayout        = true;

    dmarcReporting = enabled {
      inherit domain;

      organizationName = "Doofemshmirtz Evil Inc.";
    };

    loginAccounts."contact@${domain}" = {
      aliases = [ "@${domain}" ];

      hashedPasswordFile = config.age.secrets."cube.mail.password.hash".path;
    };
  };
}
