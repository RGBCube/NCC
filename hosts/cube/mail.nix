{ config, lib, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";
in serverSystemConfiguration {
  services.prometheus.exporters.postfix = enabled {
    port = 9020;
  };

  services.prometheus.scrapeConfigs = [{
    job_name = "mail";

    static_configs = [{
      labels.job = "postfix";
      targets    = [
        "[::]:${toString config.services.prometheus.exporters.postfix.port}"
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
