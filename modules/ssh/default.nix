{ ulib, ... }: with ulib;

homeConfiguration {
  programs.ssh = enabled {
    matchBlocks."*".setEnv.TERM  = "xterm-kitty";

    matchBlocks.cube = {
      hostname     = "5.255.78.70";
      user         = "rgb";
      port         = 2222;
      identityFile = "~/.ssh/id_rsa";
    };

    matchBlocks.robotic = {
      hostname     = "86.105.252.189";
      user         = "rgbcube";
      port         = 2299;
      identityFile = "~/.ssh/id_rsa";
    };
  };
}
