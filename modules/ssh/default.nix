{ ulib, ... }: with ulib;

homeConfiguration {
  programs.ssh = enabled {
    matchBlocks.robotic = {
      hostname     = "86.105.252.189";
      user         = "rgbcube";
      port         = 2299;
      setEnv.TERM  = "xterm-kitty";
      identityFile = "~/.ssh/id_rsa";
    };
  };
}
