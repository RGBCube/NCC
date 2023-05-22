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
      shell = [
        "nu"
        "-c"
      ];
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
  };
})

//

(imports [
  ./languageServers.nix
])
