{ lib, pkgs, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate

(homeConfiguration "nixos" {
  programs.nushell = {
    environmentVariables.EDITOR = "hx";
  };

  programs.helix = enabled {
    settings.theme = "gruvbox_dark_hard";

    settings.editor = {
      color-modes            = true;
      completion-trigger-len = 0;
      cursor-shape.insert    = "bar";
      cursorline             = true;
      idle-timeout           = 0;
      file-picker.hidden     = false;
      line-number            = "relative";
      shell                  = [ "nu" "--commands" ];
      text-width             = 100;
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

    settings.keys = lib.recursiveUpdate

    (builtins.foldl' (x: y: lib.recursiveUpdate x y) {} (builtins.map (mode: { ${mode} = {
      C-h = "move_prev_word_start";
      C-l = "move_next_word_end";
      C-k = "move_visual_line_up";
      C-j = "move_visual_line_down";

      C-left  = "move_prev_word_start";
      C-right = "move_next_word_end";
      C-up    = "move_visual_line_up";
      C-down  = "move_visual_line_down";
    }; }) [ "insert" "normal" "select" ]))

    (builtins.foldl' (x: y: lib.recursiveUpdate x y) {} (builtins.map (mode: {
      ${mode}.D = "extend_to_line_end";
    }) [ "normal" "select" ]));
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
