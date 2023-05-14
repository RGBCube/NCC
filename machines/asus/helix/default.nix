{ pkgs, homeConfiguration, imports, enabled, ... }:

(homeConfiguration "nixos" {
  programs.nushell = {
    environmentVariables = {
      EDITOR = "hx";
    };

    shellAliases = {
      e = "hx";
    };
  };

  programs.helix = enabled {
    settings.theme = "catppuccin_mocha";

    settings.editor = {
      auto-pairs."<" = ">";
      auto-pairs."`" = "`";
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

    languages = [
      {
        name = "bash";
        language-server.command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
      }
      {
        name = "python";
        roots = [ "pyproject.toml" ];
        config = {};
        auto-format = true;
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
        language-server.command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server";
      }
    ] ++ builtins.map (language: {
        name = language;
        language-server.command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
      }) [ "javascript" "jsx" "typescript" "tsx" ];
  };
})

//

(imports [
  ./languageServers.nix
])
