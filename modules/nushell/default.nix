{ config, lib, pkgs, ... }: with lib; merge

(systemConfiguration {
  users.defaultUserShell              = pkgs.crash;
  environment.sessionVariables.SHELLS = lib.getExe pkgs.nushell;

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
})

(homeConfiguration (homeArgs: {
  xdg.configFile = {
    "nushell/zoxide.nu".source = pkgs.runCommand "zoxide.nu" {} ''
      ${lib.getExe pkgs.zoxide} init nushell --cmd cd > $out
    '';

    "nushell/ls_colors.txt".source = pkgs.runCommand "ls_colors.txt" {} ''
      ${lib.getExe pkgs.vivid} generate gruvbox-dark-hard > $out
    '';
  };

  programs.starship = enabled {
    settings = {
      command_timeout = 100;
      scan_timeout    = 20;

      cmd_duration.show_notifications = isDesktop;

      package.disabled = isServer;

      character.error_symbol   = "";
      character.success_symbol = "";
    };
  };

  programs.nushell = enabled {
    configFile.text = readFile ./configuration.nu;
    envFile.source  = ./environment.nu;

    environmentVariables = let
      environmentVariables = config.environment.variables;

      homeVariables      = homeArgs.config.home.sessionVariables;
      homeVariablesExtra = pipe (pkgs.runCommand "home-variables-extra.env" {} ''
        alias export=echo
        # echo foo > $out
        # FIXME
        eval $(cat ${homeArgs.config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh) > $out
      '') [
        # (aaa: (_: break _) aaa)
        readFile
        (splitString "\n")
        (filter (s: s != ""))
        (map (strings.match "([^=]+)=(.*)"))
        (map (keyAndValue: nameValuePair (first keyAndValue) (last keyAndValue)))
        (foldl' (x: y: x // y) {})
      ];
    in mapAttrs (const (value: ''"${value}"'')) (environmentVariables // homeVariables // homeVariablesExtra);

    shellAliases = (attrsets.removeAttrs config.environment.shellAliases [ "ls" "l" ]) // {
      cdtmp = "cd (mktemp --directory)";
      ll    = "ls --long";
    };
  };
}))

(systemPackages (with pkgs; [
  fish   # For completions.
  zoxide # For completions and better cd.
]))
