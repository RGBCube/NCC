{ homeManagerConfiguration, ... }:

homeManagerConfiguration "nixos" {
  programs.git.enable = true;
  programs.git = {
    userName = "RGBCube";
    userEmail = "RGBCube@users.noreply.github.com";

    extraConfig.init.defaultBranch = "master";
  };
}
