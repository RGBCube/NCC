{ config, lib, pkgs, ... }: let
  inherit (lib) enabled const filter first foldl' getExe last match mkIf nameValuePair optionalAttrs readFile removeAttrs splitString;
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

  home-manager.sharedModules = [(homeArgs: {
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

      # package = pkgs.starship.overrideAttrs (const {
      #   src = pkgs.fetchFromGitHub {
      #     owner  = "poliorcetics";
      #     repo   = "starship";
      #     rev    = "19926e1e0aa25eddf63f93ba270d60eef023338f";
      #     hash   = "sha256-mi2O8JzXNLIF0/GuXVyf27JVV7d6zoskIjB29r5fPso=";
      #   };

      #   cargoHash = "sha256-sOjCkRHknc0SWNEItEvD6ajk/5W2kfbD1bw8T+wzGeU=";
      # });

      package = pkgs.callPackage ({
        lib,
        stdenv,
        fetchFromGitHub,
        rustPlatform,
        installShellFiles,
        cmake,
        git,
        nixosTests,
        Security,
        Foundation,
        Cocoa,
      }:

      rustPlatform.buildRustPackage {
        pname = "starship";
        version = "1.22.1";

        src = pkgs.fetchFromGitHub {
          owner  = "poliorcetics";
          repo   = "starship";
          rev    = "19926e1e0aa25eddf63f93ba270d60eef023338f";
          hash   = "sha256-mi2O8JzXNLIF0/GuXVyf27JVV7d6zoskIjB29r5fPso=";
        };

        nativeBuildInputs = [
          installShellFiles
          cmake
        ];

        buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
          Security
          Foundation
          Cocoa
        ];

        NIX_LDFLAGS = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
          "-framework"
          "AppKit"
        ];

        # tries to access HOME only in aarch64-darwin environment when building mac-notification-sys
        preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
          export HOME=$TMPDIR
        '';

        postInstall =
          ''
            presetdir=$out/share/starship/presets/
            mkdir -p $presetdir
            cp docs/public/presets/toml/*.toml $presetdir
          ''
          + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
            installShellCompletion --cmd starship \
              --bash <($out/bin/starship completions bash) \
              --fish <($out/bin/starship completions fish) \
              --zsh <($out/bin/starship completions zsh)
          '';

        cargoHash = "sha256-sOjCkRHknc0SWNEItEvD6ajk/5W2kfbD1bw8T+wzGeU=";

        nativeCheckInputs = [ git ];

        preCheck = ''
          HOME=$TMPDIR
        '';

        passthru.tests = {
          inherit (nixosTests) starship;
        };

        meta = with lib; {
          description = "Minimal, blazing fast, and extremely customizable prompt for any shell";
          homepage = "https://starship.rs";
          license = licenses.isc;
          maintainers = with maintainers; [
            danth
            davidtwco
            Br1ght0ne
            Frostman
          ];
          mainProgram = "starship";
        };
      }) {
        inherit (pkgs.darwin.apple_sdk.frameworks) Security Foundation Cocoa;
      };

      settings = {
        vcs.disabled = false;

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

        homeVariables      = homeArgs.config.home.sessionVariables;
        homeVariablesExtra = pkgs.runCommand "home-variables-extra.env" {} ''
            alias export=echo
            # echo foo > $out
            # FIXME
            eval $(cat ${homeArgs.config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh) > $out
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
