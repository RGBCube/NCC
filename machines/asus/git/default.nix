{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.git = enabled {
    userName = "RGBCube";
    userEmail = "RGBCube@users.noreply.github.com";

    extraConfig.init.defaultBranch = "master";
  };
}
