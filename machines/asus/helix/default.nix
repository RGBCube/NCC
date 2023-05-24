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
      cursor-shape.normal = "bar";
      cursor-shape.insert = "bar";
      cursorline = true;
      file-picker.hidden = false;
      line-number = "relative";
      shell = [
        "nu"
        "-c"
      ];
      statusline.mode.normal = "NORMAL";
      statusline.mode.insert = "INSERT";
      statusline.mode.select = "SELECT";
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
