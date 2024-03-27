{ config, lib, ... }: with lib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";

  prometheusPort = 9040;
in systemConfiguration {
  secrets.mailPassword.file = ./password.age;

  services.prometheus = {
    exporters.postfix = enabled {
      listenAddress = "[::1]";
      port          = prometheusPort;
    };

    scrapeConfigs = [{
      job_name = "postfix";

      static_configs = [{
        labels.job = "postfix";
        targets    = [
          "[::1]:${toString prometheusPort}"
        ];
      }];
    }];
  };

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

    dkimKeyDirectory = "/var/lib/dkim";
    mailDirectory    = "/var/lib/mail";
    sieveDirectory   = "/var/lib/sieve";

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

      hashedPasswordFile = config.secrets.mailPassword.path;
    };
  };
}
