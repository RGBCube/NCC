{ config, lib, pkgs, ... }: let
  inherit (lib) enabled getExe;
in {
  environment.systemPackages = [
    pkgs.difftastic
  ];

  home-manager.sharedModules = [(homeArgs: let
    homeConfig = homeArgs.config;
    homeLib    = homeArgs.config.lib;
  in {
    # HACK: There is no way to get libgit2 to use custom key paths so we are linking this.
    home.file.".ssh/id_ed25519".source = homeLib.file.mkOutOfStoreSymlink "${homeConfig.home.homeDirectory}/.ssh/id";

    programs.jujutsu = enabled {
      settings = let
        # TODO: mailDomain = head self.disk.mailserver.domains;
        mailDomain = "rgbcu.be";
      in {
        user.name  = "RGBCube";
        user.email = "git@${mailDomain}";

        ui.default-command = "log";
        ui.diff            = [ "${getExe pkgs.difftastic}" "--color" "always" "$left" "$right" ];

        ui.conflict-marker-style = "snapshot";
        ui.graph.style = if config.theme.cornerRadius > 0 then "curved" else "square";

        git.auto-local-bookmark  = true;
        git.push-bookmark-prefix = "change-";

        signing.sign-all = true;
        signing.backend  = "ssh";
        signing.key     = "~/.ssh/id";
      };
    };
  })];
}
