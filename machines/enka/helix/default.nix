{ lib, pkgs, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate

(homeConfiguration "nixos" {
  programs.nushell = {
    environmentVariables.EDITOR = "hx";
  };

  programs.helix = enabled {
    settings.theme = "gruvbox_dark_hard";

    settings.editor = {
      color-modes         = true;
      cursor-shape.insert = "bar";
      cursorline          = true;
      file-picker.hidden  = false;
      line-number         = "relative";
      shell               = [ "nu" "--commands" ];
      text-width          = 100;
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

    settings.keys.normal.D = "extend_to_line_end";
  };
})

(with pkgs; homePackages "nixos" [
  # CMAKE
  cmake-language-server

  # GO
  gopls

  # KOTLIN
  kotlin-language-server

  # LATEX
  texlab

  # LUA
  lua-language-server

  # MARKDOWN
  marksman

  # NIX
  nil

  # RUST
  rust-analyzer

  # ZIG
  zls
])
