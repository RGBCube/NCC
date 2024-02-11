{ lib, ulib, pkgs, ... }: with ulib; merge

(homeConfiguration {
  programs.nushell.shellAliases = {
    g = "git";

    ga  = "git add";
    gaa = "git add ./";

    gab  = "git absorb";
    gabr = "git absorb --and-rebase";

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

  programs.nushell.configFile.text = lib.mkAfter ''
    # Sets the remote origin to the specified user and repository on my git instance
    def gsr [user_and_repo: string] {
      let user_and_repo = if ($user_and_repo | str index-of "/") != -1 {
        $user_and_repo
      } else {
        "RGBCube/" + $user_and_repo
      }

      git remote add origin ("https://git.rgbcu.be/" + $user_and_repo)
    }
  '';

  programs.git = enabled {
    package = pkgs.gitFull;

    userName  = "RGBCube";
    userEmail = "git@rgbcu.be";

    lfs = enabled {};

    extraConfig = {
      init.defaultBranch   = "master";
      push.autoSetupRemote = true;

      core.sshCommand                       = "ssh -i ~/.ssh/id";

      url."ssh://git@github.com/".insteadOf        = "https://github.com/";
      url."ssh://forgejo@rgbcu.be:2222/".insteadOf = "https://git.rgbcu.be/";
    } // lib.optionalAttrs ulib.isDesktop {
      commit.gpgSign  = true;
      gpg.format      = "ssh";
      user.signingKey = "~/.ssh/id";
    };
  };
})

(systemPackages (with pkgs; [
  git-absorb
]))
