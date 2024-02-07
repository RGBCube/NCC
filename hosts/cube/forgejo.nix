{ config, ulib, pkgs, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "git.${domain}";
in serverSystemConfiguration {
  age.secrets."cube/password.mail.forgejo".owner   = "forgejo";
  age.secrets."cube/password.runner.forgejo".owner = "forgejo";

  services.postgresql = {
    ensureDatabases = [ "forgejo" ];
    ensureUsers     = [{
      name = "forgejo";
      ensureDBOwnership = true;
    }];
  };

  users.groups.gitea-runner = {};
  users.users.gitea-runner  = systemUser {
    extraGroups = [ "docker" ];
    group       = "gitea-runner";
    home        = "/var/lib/gitea-runner";
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;

    instances.runner-01 = enabled {
      name = "runner-01";
      url  = fqdn;

      labels = [
        "debian-latest:docker://node:18-bullseye"
        "ubuntu-latest:docker://node:18-bullseye"
        "act:docker://ghcr.io/catthehacker/ubuntu:act-latest"
      ];

      tokenFile = config.age.secrets."cube/password.runner.forgejo".path;

      settings = {
        cache.enabled     = true;
        capacity          = 4;
        container.network = "host";
      };

      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gitMinimal
        sudo
        wget
      ];
    };
  };


  services.forgejo = enabled {
    lfs = enabled {};

    mailerPasswordFile = config.age.secrets."cube/password.mail.forgejo".path;

    database = {
      socket = "/run/postgresql";
      type   = "postgres";
    };

    settings = let
      description = "RGBCube's Forge of Shitty Software";
    in {
      default.APP_NAME = description;

      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "https://${fqdn}";
      };

      attachment.ALLOWED_TYPES = "*/*";

      cache.ENABLED = true;

      mailer = {
        ENABLED = true;

        PROTOCOL = "smtps";
        SMTP_ADDR = config.mailserver.fqdn;
        USER = "git@${domain}";
      };

      other = {
        SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
        SHOW_FOOTER_VERSION            = false;
      };

      packages.ENABLED = false;

      repository = {
        DEFAULT_BRANCH      = "master";
        DEFAULT_MERGE_STYLE = "rebase-merge";
        DEFAULT_REPO_UNITS  = "repo.code, repo.issues, repo.pulls, repo.actions";

        DEFAULT_PUSH_CREATE_PRIVATE = false;
        ENABLE_PUSH_CREATE_ORG      = true;
        ENABLE_PUSH_CREATE_USER     = true;

        DISABLE_STARS = true;
      };

      "repository.upload" = {
        FILE_MAX_SIZE = 100;
        MAX_FILES = 10;
      };

      server = {
        DOMAIN       = domain;
        ROOT_URL     = "https://${fqdn}/";
        LANDING_PAGE = "/explore";

        HTTP_ADDR = "::";
        HTTP_PORT = 8004;

        SSH_PORT = builtins.elemAt config.services.openssh.ports 0;

        DISABLE_ROUTER_LOG = true;
      };

      service.DISABLE_REGISTRATION = true;

      session = {
        COOKIE_SECURE = true;
        SAME_SITE     = "strict";
      };

      "ui.meta" = {
        AUTHOR      = description;
        DESCRIPTION = description;
      };
    };
  };

  services.nginx.virtualHosts.${fqdn} = (sslTemplate domain) // {
    locations."/".proxyPass = "http://[::]:${toString config.services.forgejo.settings.server.HTTP_PORT}";
  };
}
