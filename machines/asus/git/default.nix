{ homeManagerConfiguration, ... }:

homeManagerConfiguration {
  programs.git.enable = true;
  programs.git = {
    userName = "RGBCube";
    userEmail = "RGBCube@users.noreply.github.com";

    config.init.defaultBranch = "master";
  };
}
