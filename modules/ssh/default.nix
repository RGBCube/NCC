{ self, config, lib, pkgs, ... }: with lib; merge

(systemConfiguration {
  secrets.sshConfig = {
    file = ./config.age;
    mode = "444";
  };
})

(desktopSystemPackages (with pkgs; [
  mosh
]))

(let
  controlPath = "~/.ssh/control";
in homeConfiguration {
  home.activation.createControlPath = {
    after = [ "writeBoundary" ];
    data  = "mkdir --parents ${controlPath}";
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

      cube = {
        hostname = self.cube.networking.ipv4;
        user     = "rgb";
        port     = 2222;
      };

      disk = {
        hostname = self.disk.networking.ipv4;
        user     = "floppy";
        port     = 2222;
      };

      tard = {
        hostname = self.tard.networking.ipv4;
        user     = "tail";
        port     = 2222;
      };

      robotic = {
        hostname = "86.105.252.189";
        user     = "rgbcube";
        port     = 2299;
      };
    };
  };
})

(let
  port = 2222;
in serverSystemConfiguration {
  programs.mosh = enabled {
    openFirewall = true;
  };

  services.openssh = enabled {
    ports    = [ port ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;

      AcceptEnv = "SHELLS COLORTERM";
    };
  };
})
