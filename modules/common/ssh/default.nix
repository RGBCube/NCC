{ self, config, lib, pkgs, ... }: let
  inherit (lib) enabled mkIf filterAttrs attrNames mapAttrs head remove;

  controlPath = "~/.ssh/control";

  hosts = self.nixosConfigurations
    |> filterAttrs (_: value: value.config.services.openssh.enable)
    |> mapAttrs (_: value: {
      hostname = value.config.networking.ipv4.address;

      user = value.config.users.users
        |> attrNames
        |> remove "root"
        |> remove "backup"
        |> head;
    });
in {
  secrets.sshConfig = {
    file = ./config.age;
    mode = "444";
  };

  home-manager.sharedModules = [{
    home.activation.createControlPath = {
      after  = [ "writeBoundary" ];
      before = [];
      data   = "mkdir --parents ${controlPath}";
    };

    programs.ssh = enabled {
      controlMaster       = "auto";
      controlPath         = "${controlPath}/%r@%n:%p";
      controlPersist      = "60m";
      serverAliveCountMax = 2;
      serverAliveInterval = 60;

      includes = [ config.secrets.sshConfig.path ];

      matchBlocks = hosts // {
        "*" = {
          setEnv.COLORTERM = "truecolor";
          setEnv.TERM      = "xterm-256color";

          identityFile = "~/.ssh/id";
        };
      };
    };
  }];

  environment.systemPackages = mkIf config.isDesktop [
    pkgs.mosh
  ];
}
