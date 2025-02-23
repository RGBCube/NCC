{ self, config, lib, pkgs, ... }: let
  inherit (config.networking) domain;
  inherit (lib) const enabled genAttrs head merge mkForce;

  fqdn = "git.${domain}";

  port = 8001;
in {
  imports = [(self + /modules/nginx.nix)];

  secrets.forgejoPasswordRunner = {
    file  = ./password.runner.age;
    owner = "forgejo";
  };
  secrets.forgejoPasswordMail = {
    file  = self + /modules/mail/password.plain.age;
    owner = "forgejo";
  };

  services.postgresql = let
    users = [ "forgejo" ];
  in {
    ensureDatabases = users;
    ensureUsers     = map users (name: {
      inherit name;

      ensureDBOwnership = true;
    });
  };

  services.restic.backups = genAttrs config.services.restic.hosts <| const {
    paths = [ "/var/lib/gitea-runner"  "/var/lib/forgejo" ];
  };

  users.groups.gitea-runner = {};
  users.users.gitea-runner  = {
    extraGroups  = [ "docker" ];
    group        = "gitea-runner";
    home         = "/var/lib/gitea-runner";
    isSystemUser = true;
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

      tokenFile = config.secrets.forgejoPasswordRunner.path;

      settings = {
        cache.enabled     = true;
        capacity          = 4;
        container.network = "host";
      };

      hostPackages = [
        pkgs.bash
        pkgs.uutils-coreutils-noprefix
        pkgs.curl
        pkgs.gitMinimal
        pkgs.sudo
        pkgs.wget
      ];
    };
  };

  services.openssh.settings.AcceptEnv = mkForce "SHELLS COLOTERM GIT_PROTOCOL";

  services.forgejo = enabled {
    lfs = enabled;

    secrets.mailer.PASSWD = config.secrets.forgejoPasswordMail.path;

    database = {
      socket = "/run/postgresql";
      type   = "postgres";
    };

    settings = let
      description = "RGBCube's Forge of Shitty Software";
    in {
      default.APP_NAME = description;

      actions = {
        ENABLED             = true;
        DEFAULT_ACTIONS_URL = "https://${fqdn}";
      };

      attachment.ALLOWED_TYPES = "*/*";

      cache.ENABLED = true;

      mailer = {
        ENABLED = true;

        PROTOCOL  = "smtps";
        SMTP_ADDR = self.disk.mailserver.fqdn;
        USER      = "git@${domain}";
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

        HTTP_ADDR = "::1";
        HTTP_PORT = port;

        SSH_PORT = head config.services.openssh.ports;

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

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    locations."/".proxyPass = "http://[::1]:${toString port}";
  };
}
