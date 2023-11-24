{ lib, ulib, pkgs, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate

(homeConfiguration [ "nixos" "root" ] {
  programs.nushell.environmentVariables.EDITOR = "hx";
  programs.nushell.shellAliases.x              = "hx";

  programs.helix = enabled {
    settings.theme = "gruvbox_dark_hard";

    settings.editor = {
      color-modes         = true;
      completion-replace  = true;
      cursor-shape.insert = "bar";
      cursorline          = true;
      bufferline          = "multiple";
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

    settings.keys = lib.recursiveUpdate

    (ulib.recursiveUpdateMap (mode: { ${mode} = {
      C-h = "move_prev_word_start";
      C-l = "move_next_word_end";
      C-k = "move_visual_line_up";
      C-j = "move_visual_line_down";

      C-left  = "move_prev_word_start";
      C-right = "move_next_word_end";
      C-up    = "move_visual_line_up";
      C-down  = "move_visual_line_down";
    }; }) [ "insert" "normal" "select" ])

    (ulib.recursiveUpdateMap (mode: {
      ${mode}.D = "extend_to_line_end";
    }) [ "normal" "select" ]);
  };
})

(with pkgs; homePackages "nixos" [
  # CMAKE
  cmake-language-server

  # GO
  gopls

  # HTML
  vscode-langservers-extracted

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
