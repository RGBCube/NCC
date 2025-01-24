{ config, lib, pkgs, ... }: let
  inherit (lib) enabled filter first foldl' getExe last match mkIf nameValuePair optionalAttrs readFile removeAttrs splitString;
in {
  users = optionalAttrs config.isLinux { defaultUserShell = pkgs.nushell; };

  environment.shells = mkIf config.isDarwin [ pkgs.nushell ];

  environment.shellAliases = {
    la  = "ls --all";
    lla = "ls --long --all";
    sl  = "ls";

    cp = "cp --recursive --verbose --progress";
    mk = "mkdir";
    mv = "mv --verbose";
    rm = "rm --recursive --verbose";

    pstree = "pstree -g 2";
    tree   = "tree -CF --dirsfirst";
  };

  environment.systemPackages = [
    pkgs.fish   # For completions.
    pkgs.zoxide # For completions and better cd.
  ];

  environment.variables.STARSHIP_LOG = "error";

  nixpkgs.overlays = [(self: super: {
    starship = super.starship.overrideAttrs (old: {
      src = self.fetchFromGitHub {
        owner  = "poliorcetics";
        repo   = "starship";
        rev    = "19926e1e0aa25eddf63f93ba270d60eef023338f";
        hash   = "sha256-mi2O8JzXNLIF0/GuXVyf27JVV7d6zoskIjB29r5fPso=";
      };

      cargoDeps = super.starship.cargoDeps.overrideAttrs (_: {
        inherit (self.starship) src;
        outputHash = "sha256-3NJV+hsgX3H8pycso0gCdzxJg8SgVwGMbIoHDDRZBvY=";
      });
    });
  })];

  home-manager.sharedModules = [(homeArgs: let
    homeConfig = homeArgs.config;
  in {
    xdg.configFile = {
      "nushell/zoxide.nu".source = pkgs.runCommand "zoxide.nu" {} ''
        ${getExe pkgs.zoxide} init nushell --cmd cd > $out
      '';

      "nushell/ls_colors.txt".source = pkgs.runCommand "ls_colors.txt" {} ''
        ${getExe pkgs.vivid} generate gruvbox-dark-hard > $out
      '';

      "nushell/starship.nu".source = pkgs.runCommand "starship.nu" {} ''
        ${getExe pkgs.starship} init nu > $out
      '';
    };

    programs.starship = enabled {
      # No because we are doing it at build time instead of the way
      # this retarded module does it. Why the hell do you generate
      # the config every time the shell is launched?
      enableNushellIntegration = false;

      settings = {
        vcs.disabled = false;

        swift.disabled = true;

        command_timeout = 100;
        scan_timeout    = 20;

        cmd_duration.show_notifications = config.isDesktop;

        package.disabled = config.isServer;

        character.error_symbol   = "";
        character.success_symbol = "";
      };
    };

    programs.nushell = enabled {
      configFile.text = readFile ./configuration.nu;
      envFile.text    = readFile ./environment.nu;

      environmentVariables = let
        environmentVariables = config.environment.variables;

        homeVariables      = homeConfig.home.sessionVariables;
        homeVariablesExtra = pkgs.runCommand "home-variables-extra.env" {} ''
            alias export=echo
            # echo foo > $out
            # FIXME
            eval $(cat ${homeConfig.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh) > $out
          ''
            # |> (aaa: (_: break _) aaa)
            |> readFile
            |> splitString "\n"
            |> filter (s: s != "")
            |> map (match "([^=]+)=(.*)")
            |> map (keyAndValue: nameValuePair (first keyAndValue) (last keyAndValue))
            |> foldl' (x: y: x // y) {};
      in environmentVariables // homeVariables // homeVariablesExtra;

      shellAliases = removeAttrs config.environment.shellAliases [ "ls" "l" ] // {
        cdtmp = "cd (mktemp --directory)";
        ll    = "ls --long";
      };
    };
  })];
}
