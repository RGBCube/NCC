{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.nushell.shellAliases = {
    g = "git";
    ga = "git add ./";
    grb = "git rebase -i";
    grba = "git rebase --abort";
    gc = "git commit -m";
    gca = "git commit --amend";
    gcl = "git clone";
    gd = "git diff";
    gds = "git diff --staged";
    gp = "git push";
    gs = "git stash";
    gss = "git status";
  };

  programs.git = enabled {
    userName = "RGBCube";
    userEmail = "RGBCube@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "master";

      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_rsa";
      commit.gpgSign = true;
    };
  };
}
