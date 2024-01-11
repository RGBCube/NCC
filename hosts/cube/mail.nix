{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.nginx.virtualHosts.${config.mailserver.fqdn}.useACMEHost = config.networking.domain;

  mailserver = enabled {
    domains = [ config.networking.domain ];
    fqdn    = "mail.${config.networking.domain}";

    certificateScheme = "acme";

    hierarchySeparator = "/";
    useFsLayout        = true;

    loginAccounts."contact@${config.networking.domain}" = {
      aliases = [ "@${config.networking.domain}" ];

      hashedPasswordFile = config.age.secrets."cube.mail.password.hash".path;
    };
  };
}
