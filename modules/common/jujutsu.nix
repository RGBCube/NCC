{ self, config, lib, pkgs, ... }: let
  inherit (lib) attrValues enabled getExe head;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
      difftastic
      radicle-node
    ;
  };

  home-manager.sharedModules = [(homeArgs: let
    homeConfig = homeArgs.config;
    homeLib    = homeArgs.config.lib;
  in {
    # HACK: There is no way to get libgit2 to use custom key paths so we are linking this.
    home.file.".ssh/id_ed25519".source = homeLib.file.mkOutOfStoreSymlink "${homeConfig.home.homeDirectory}/.ssh/id";

    programs.jujutsu = enabled {
      settings = let
        mailDomain = head self.disk.mailserver.domains;
      in {
        user.name  = "RGBCube";
        user.email = "git@${mailDomain}";

        aliases.".." = [ "edit" "@-" ];
        aliases.",," = [ "edit" "@+" ];

        aliases.fetch = [ "git" "fetch" ];
        aliases.f     = [ "git" "fetch" ];

        aliases.push = [ "git" "push" ];
        aliases.p    = [ "git" "push" ];

        aliases.clone = [ "git" "clone" "--colocate" ];
        aliases.cl    = [ "git" "clone" "--colocate" ];

        aliases.init = [ "git" "init" "--colocate" ];
        aliases.i    = [ "git" "init" "--colocate" ];

        aliases.c  =   "commit";
        aliases.ci = [ "commit" "--interactive" ];

        aliases.e = "edit";
        aliases.r = "rebase";

        aliases.s  =   "squash";
        aliases.si = [ "squash" "--interactive" ];

        aliases.d  = "diff";

        aliases.tug = [ "bookmark" "move" "--from" "closest_bookmark(@-)" "--to" "@-" ];

        revset-aliases."closest_bookmark(to)" = "heads(::to & bookmarks())";

        revsets.log = "present(@) | present(trunk()) | ancestors(remote_bookmarks().., 2) | reachable(@, all())";

        ui.default-command = "status";

        ui.diff-editor     = ":builtin";
        ui.diff.tool       = [ "${getExe pkgs.difftastic}" "--color" "always" "$left" "$right" ];

        ui.conflict-marker-style = "snapshot";
        ui.graph.style           = if config.theme.cornerRadius > 0 then "curved" else "square";

        templates.draft_commit_description = /* python */ ''
          concat(
            coalesce(description, "\n"),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';

        git.auto-local-bookmark  = true;
        git.push-bookmark-prefix = "change-";
        git.subprocess           = true;

        git.fetch = [ "origin" "upstream" "rad" ];
        git.push  =   "origin";

        signing.backend  = "ssh";
        signing.behavior = "own";
        signing.key      = "~/.ssh/id";
      };
    };
  })];
}
