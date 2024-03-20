{ lib, ulib, pkgs, ... }: with ulib; merge3

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
    gpf = "git push --force-with-lease";

    gl  = "git log";
    glo = "git log --oneline";
    glp = "git log -p --ext-diff";

    gpl   = "git pull";
    gplr  = "git pull --rebase";
    gplff = "git pull --ff-only";

    gr = "git recent";

    grb  = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase --interactive";
    grbm = "git rebase master";

    grl = "git reflog";

    grm   = "git remote";
    grma  = "git remote add";
    grmv  = "git remote --verbose";
    grmsu = "git remote set-url";

    grs  = "git reset";
    grsh = "git reset --hard";

    gs  = "git stash";
    gsp = "git stash pop";

    gsw  = "git switch";
    gswm = "git switch master";

    gsh = "git show --ext-diff";

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

    difftastic = enabled {
      background = "dark";
    };

    extraConfig = lib.recursiveUpdate {
      init.defaultBranch = "master";

      commit.verbose = true;

      log.date  = "iso";
      column.ui = "auto";

      branch.sort = "-committerdate";
      tag.sort    = "version:refname";

      diff.algorithm  = "histogram";
      diff.colorMoved = "default";

      pull.rebase          = true;
      push.autoSetupRemote = true;

      merge.conflictStyle = "zdiff3";

      rebase.autoSquash = true;
      rebase.autoStash  = true;
      rerere.enabled    = true;

      fetch.fsckObjects    = true;
      receive.fsckObjects  = true;
      transfer.fsckobjects = true;

      # https://bernsteinbear.com/git
      alias.recent = "! git branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\" | head -10";

      core.sshCommand                              = "ssh -i ~/.ssh/id";
      url."ssh://git@github.com/".insteadOf        = "https://github.com/";
      url."ssh://forgejo@rgbcu.be:2222/".insteadOf = "https://git.rgbcu.be/";
    } (lib.optionalAttrs ulib.isDesktop {
      commit.gpgSign  = true;
      tag.gpgSign     = true;
      gpg.format      = "ssh";
      user.signingKey = "~/.ssh/id";
    });
  };
})

(desktopHomeConfiguration {
  programs.nushell.shellAliases = {
    "??"   = "gh copilot suggest --target shell";
    "gh?"  = "gh copilot suggest --target gh";
    "git?" = "gh copilot suggest --target git";
  };

  programs.gh = enabled {
    settings.git_protocol = "ssh";
  };
})

(systemPackages (with pkgs; [
  git-absorb
  tig
]))
