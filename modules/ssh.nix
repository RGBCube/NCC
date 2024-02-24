{ ulib, pkgs, ... }: with ulib; merge

(desktopSystemPackages (with pkgs; [
  mosh
]))

(desktopHomeConfiguration {
  programs.ssh = enabled {
    controlMaster       = "auto";
    controlPersist      = "60m";
    serverAliveCountMax = 2;
    serverAliveInterval = 60;

    matchBlocks."*".setEnv = {
      COLORTERM = "truecolor";
      TERM      = "xterm-256color";
    };

    matchBlocks.cube = {
      hostname     = "5.255.78.70";
      user         = "rgb";
      port         = 2222;
      identityFile = "~/.ssh/id";
    };

    matchBlocks.robotic = {
      hostname     = "86.105.252.189";
      user         = "rgbcube";
      port         = 2299;
      identityFile = "~/.ssh/id";
    };
  };
})
