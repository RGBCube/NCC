{ lib, pkgs, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate

(homeConfiguration "nixos" {
  programs.helix = enabled {
    defaultEditor = true;

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
      normal = "NORMAL";
      insert = "INSERT";
      select = "SELECT";
    };

    settings.editor.whitespace = {
      render.tab     = "all";
      characters.tab = "→";
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
