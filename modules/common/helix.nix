{ config, lib, pkgs, ... }: let
  inherit (lib) const enabled genAttrs mkAfter mkIf;
in {
  environment = {
    variables.EDITOR = "hx";
    shellAliases.x   = "hx";
  };

  home-manager.sharedModules = [{
    programs.nushell.configFile.text = mkIf (config.isDesktop && config.isLinux) <| mkAfter ''
      def --wrapped hx [...arguments] {
        if $env.TERM == "xterm-kitty" {
          kitty @ set-spacing padding=0
        }

        ^hx ...$arguments

        if $env.TERM == "xterm-kitty" {
          kitty @ set-spacing padding=${toString config.theme.padding}
        }
      }
    '';

    programs.helix = enabled {
      languages.language = let
        denoFormatter = language: {
          command = "deno";
          args    = [ "fmt" "-" "--ext" language ];
        };

        denoFormatterLanguages = map (name: {
          inherit name;

          auto-format = true;
          formatter   = denoFormatter name;
        }) [ "markdown" "json" ];

        prettier = language: {
          command = "prettier";
          args    = [ "--parser" language ];
        };

        prettierLanguages = map (name: {
          inherit name;

          auto-format = true;
          formatter   = prettier name;
        }) [ "css" "scss" "yaml" ];
      in denoFormatterLanguages ++ prettierLanguages ++ [
        {
          name              = "nix";
          auto-format       = false;
          formatter.command = "alejandra";
        }
        {
          name        = "html";
          # Added vto.
          file-types  = [ "asp" "aspx" "htm" "html" "jshtm" "jsp" "rhtml" "shtml" "volt" "vto" "xht" "xhtml" ];
          auto-format = false;
          formatter   = prettier "html";
        }
        {
          name             = "javascript";
          auto-format      = true;
          formatter        = denoFormatter "js";
          language-servers = [ "deno" ];
        }
        {
          name             = "jsx";
          auto-format      = true;
          formatter        = denoFormatter "jsx";
          language-servers = [ "deno" ];
        }
        {
          name             = "typescript";
          auto-format      = true;
          formatter        = denoFormatter "ts";
          language-servers = [ "deno" ];
        }
        {
          name             = "tsx";
          auto-format      = true;
          formatter        = denoFormatter "tsx";
          language-servers = [ "deno" ];
        }
      ];

      languages.language-server = {
        deno = {
          command = "deno";
          args    = [ "lsp" ];

          environment.NO_COLOR = "1";

          config.deno = enabled {
            lint     = true;
            unstable = true;

            suggest.imports.hosts."https://deno.land" = true;

            inlayHints = {
              enumMemberValues.enabled         = true;
              functionLikeReturnTypes.enabled  = true;
              parameterNames.enabled           = "all";
              parameterTypes.enabled           = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled            = true;
            };
          };
        };

        rust-analyzer.config.check.command = "clippy";
      };

      settings.theme = "gruvbox_dark_hard";

      settings.editor = {
        bufferline              = "multiple";
        color-modes             = true;
        completion-replace      = true;
        completion-trigger-len  = 0;
        cursor-shape.insert     = "bar";
        cursorline              = true;
        file-picker.hidden      = false;
        idle-timeout            = 0;
        line-number             = "relative";
        shell                   = [ "bash" "-c" ];
        text-width              = 100;
      };

      settings.editor.indent-guides = {
        character = "▏";
        render = true;
      };

      settings.editor.statusline.mode = {
        insert = "INSERT";
        normal = "NORMAL";
        select = "SELECT";
      };

      settings.editor.whitespace = {
        characters.tab = "→";
        render.tab     = "all";
      };

      settings.keys = genAttrs [ "normal" "select" ] (const {
        D = "extend_to_line_end";
      });
    };
  }];

  environment.systemPackages = mkIf config.isDesktop [
    # CMAKE
    pkgs.cmake-language-server

    # GO
    pkgs.gopls

    # HTML
    pkgs.vscode-langservers-extracted
    pkgs.nodePackages_latest.prettier

    # KOTLIN
    pkgs.kotlin-language-server

    # LATEX
    pkgs.texlab

    # LUA
    pkgs.lua-language-server

    # MARKDOWN
    pkgs.marksman

    # NIX
    pkgs.alejandra
    pkgs.nil

    # PYTHON
    pkgs.python311Packages.python-lsp-server

    # RUST
    pkgs.rust-analyzer-nightly

    # TYPESCRIPT & OTHERS
    pkgs.deno

    # YAML
    pkgs.yaml-language-server

    # ZIG
    pkgs.zls
  ];
}

