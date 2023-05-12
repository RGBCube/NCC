{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.nushell.shellAliases = {
    g = "git";
    ga = "git add ./";
    gb = "git rebase -i";
    gc = "git commit -m";
    gca = "git commit --amend";
    gcl = "git clone";
    gd = "git diff";
    gds = "git diff --staged";
    gp = "git push";
    gs = "git status";
  };

  programs.git = enabled {
    userName = "RGBCube";
    userEmail = "RGBCube@users.noreply.github.com";

    extraConfig.init.defaultBranch = "master";
  };
}
