{ lib, ulib, pkgs, ... }: with ulib;

homeConfiguration {
  programs.nushell.shellAliases = {
    g = "git";

    ga  = "git add";
    gaa = "git add ./";

    gb  = "git branch";
    gbv = "git branch --verbose";

    gc   = "git commit";
    gca  = "git commit --amend --no-edit";
    gcm  = "git commit --message";
    gcam = "git commit --amend --message";

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
    userEmail = "git@rgbcu.be";

    lfs = enabled {};

    extraConfig = {
      init.defaultBranch   = "master";
      push.autoSetupRemote = true;

      core.sshCommand                       = "ssh -i ~/.ssh/id";
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    } // lib.optionalAttrs ulib.isDesktop {
      commit.gpgSign  = true;
      gpg.format      = "ssh";
      user.signingKey = "~/.ssh/id";
    };
  };
}
