{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";
in serverSystemConfiguration {
  services.prometheus.exporters = {
    dmarc = enabled {
      imap.host         = domain;
      imap.passwordFile = config.age.secrets."cube.mail.password".path;
      imap.username     = "contact@${domain}";
    };

    dovecot = enabled {};
    postfix = enabled {};
    rspamd  = enabled {};
  };

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
