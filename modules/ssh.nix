{ self, lib, pkgs, ... }: with lib; merge

(desktopSystemPackages (with pkgs; [
  mosh
]))

(homeConfiguration {
  programs.ssh = enabled {
    controlMaster       = "auto";
    controlPersist      = "60m";
    serverAliveCountMax = 2;
    serverAliveInterval = 60;

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

      AcceptEnv = "COLORTERM";
    };
  };
})
