{ pkgs, homeConfiguration, systemPackages, imports, enabled, ... }:

(with pkgs; systemPackages [
  xclip
])

//

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
      cursorline = true;
      file-picker.hidden = false;
      line-number = "relative";
      shell = [
        "nu"
        "-c"
      ];
      text-width = 100;
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

    settings.editor.cursor-shape = {
      normal = "bar";
      insert = "bar";
    };

    settings.editor.mode = {
      normal = "NORMAL";
      insert = "INSERT";
      select = "SELECT";
    };

    settings.editor.whitespace = {
      render.tab = "all";
      characters.tab = "→";
    };
  };
})

//

(imports [
  ./languageServers.nix
])
