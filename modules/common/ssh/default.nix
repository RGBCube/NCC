{ self, config, lib, pkgs, ... }: let
  inherit (lib) enabled mkIf;

  controlPath = "~/.ssh/control";
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

      matchBlocks = {
        "*" = {
          setEnv.COLORTERM = "truecolor";
          setEnv.TERM      = "xterm-256color";

          identityFile = "~/.ssh/id";
        };

        # TODO: Maybe autogenerate these?

        # cube = {
        #   hostname = self.cube.networking.ipv4;
        #   user     = "rgb";
        #   port     = 2222;
        # };

        disk = {
          hostname = self.disk.networking.ipv4;
          user     = "floppy";
          port     = 2222;
        };

        nine = {
          hostname = self.nine.networking.ipv4;
          user     = "seven";
          port     = 2222;
        };
      };
    };
  }];

  environment.systemPackages = mkIf config.isDesktop [
    pkgs.mosh
  ];
}
