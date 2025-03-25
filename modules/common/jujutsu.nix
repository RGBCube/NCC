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

        revsets.log = "present(@) | present(trunk()) | ancestors(remote_bookmarks().., 2) | reachable(@, all())";

        ui.default-command = "status";

        ui.diff-editor     = ":builtin";
        ui.diff.tool       = [ "${getExe pkgs.difftastic}" "--color" "always" "$left" "$right" ];

        ui.conflict-marker-style = "snapshot";
        ui.graph.style = if config.theme.cornerRadius > 0 then "curved" else "square";

        git.auto-local-bookmark  = true;
        git.push-bookmark-prefix = "change-";
        git.subprocess           = true;

        git.fetch = [ "origin" "upstream" "rad" ];
        git.push  = "origin"; # TODO: Find a way to make this become rad when origin is up to date.

        signing.sign-all = true;
        signing.backend  = "ssh";
        signing.key     = "~/.ssh/id";
      };
    };
  })];
}
