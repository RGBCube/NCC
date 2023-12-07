{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration [ "nixos" "root" ] {
  programs.nushell.shellAliases = {
    g = "git";

    ga  = "git add";
    gaa = "git add ./";

    gc  = "git commit";
    gca = "git commit --amend --no-edit";
    gcm = "git commit --message";

    gcl = "git clone";

    gd  = "git diff";
    gds = "git diff --staged";

    gp  = "git push";
    gpf = "git push --force";

    gl  = "git log";
    glo = "git log --oneline";
    glp = "git log -p --full-diff";

    gpl   = "git pull";
    gplr  = "git pull --rebase";
    gplff = "git pull --ff-only";

    grb  = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase --interactive";
    grbm = "git rebase master";

    grl = "git reflog";

    grs  = "git reset";
    grsh = "git reset --hard";

    gs  = "git stash";
    gsp = "git stash pop";

    gsw  = "git switch";
    gswm = "git switch master";

    gsh = "git show";

    gst = "git status";
  };

  programs.git = enabled {
    package = pkgs.gitFull;

    userName  = "RGBCube";
    userEmail = "RGBCube@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch   = "master";
      push.autoSetupRemote = true;

      commit.gpgSign  = true;
      gpg.format      = "ssh";
      user.signingKey = "~/.ssh/id_rsa";

      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
