{ pkgs, homeConfiguration, imports, enabled, ... }:

(homeConfiguration "nixos" {
  programs.nushell = {
    environmentVariables = {
      EDITOR = "hx";
    };
  };

  programs.helix = enabled {
    settings.theme = "catppuccin_mocha";

    settings.editor = {
      color-modes = true;
      cursor-shape.normal = "bar";
      cursorline = true;
      file-picker.hidden = false;
      line-number = "relative";
      shell = [ "nu" "-c" ];
      text-width = 100;
      whitespace.render.tab = "all";
      whitespace.characters.tab = "→";
    };

    settings.editor.auto-pairs = {
      "(" = ")";
      "{" = "}";
      "[" = "]";
      "\"" = "\"";
      "'" = "'";
      "<" = ">";
      "`" = "`";
    };

    languages = [
      {
        name = "bash";
        scope = "scope.sh";
        language-server.command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
      }
      {
        name = "python";
        scope = "scope.py";
        roots = [ "pyproject.toml" ];
        config = {};
        formatter = {
          command = "black";
          args = [ "-" "--quiet" ];
        };
        language-server = {
          command = "${pkgs.nodePackages.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
        };
      }
      {
        name = "yaml";
        scope = "scope.yml";
        language-server = {
          command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server";
          args = [ "--stdio" ];
        };
      }
      {
        name = "js";
        scope = "scope.js";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      }
      {
        name = "jsx";
        scope = "scope.jsx";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      }
      {
        name = "typescript";
        scope = "scope.ts";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      }
      {
        name = "tsx";
        scope = "scope.tsx";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      }
    ];
  };
})

//

(imports [
  ./languageServers.nix
])
