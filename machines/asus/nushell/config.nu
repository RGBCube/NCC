let theme = {
  filesize: { |size|
    if $size == 0b {
      'white'
    } else if $size < 1mb {
      'cyan'
    } else {
      'blue'
    }
  }

  date: { ||
    (date now) - $in |
      if $in < 1hr {
        'red3b'
      } else if $in < 6hr {
        'orange3'
      } else if $in < 1day {
        'yellow3b'
      } else if $in < 3day {
        'chartreuse2b'
      } else if $in < 1wk {
        'green3b'
      } else if $in < 6wk {
        'darkturquoise'
      } else if $in < 52wk {
        'deepskyblue3b'
      } else {
        'dark_gray'
      }
  }

  bool: { ||
    if $in {
      'light_cyan'
    } else {
      'light_gray'
    }
  }

  leading_trailing_space_bg: {
    attr: n
  }

  empty: blue
  hints: dark_gray
  header: green_bold
  row_index: green_bold
  separator: white
  duration: white
  int: white
  range: white
  float: white
  string: white
  nothing: white
  binary: white
  cellpath: white
  record: white
  list: white
  block: white

  shape_garbage: {
    fg: "#FFFFFF"
    bg: "#FF0000"
    attr: b
  }

  shape_matching_brackets: {
    attr: u
  }

  shape_and: purple_bold
  shape_binary: purple_bold
  shape_block: blue_bold
  shape_bool: light_cyan
  shape_custom: green
  shape_datetime: cyan_bold
  shape_directory: cyan
  shape_external: cyan
  shape_externalarg: green_bold
  shape_filepath: cyan
  shape_flag: blue_bold
  shape_float: purple_bold
  shape_globpattern: cyan_bold
  shape_int: purple_bold
  shape_internalcall: cyan_bold
  shape_list: cyan_bold
  shape_match_pattern: green
  shape_literal: blue
  shape_nothing: light_cyan
  shape_operator: yellow
  shape_or: purple_bold
  shape_pipe: purple_bold
  shape_range: yellow_bold
  shape_record: cyan_bold
  shape_redirection: purple_bold
  shape_signature: green_bold
  shape_string: green
  shape_string_interpolation: cyan_bold
  shape_table: blue_bold
  shape_variable: purple
}


let-env config = {
  show_banner: false

  ls: {
    use_ls_colors: true
    clickable_links: true
  }

  rm: {
    always_trash: false
  }

  cd: {
    abbreviations: false
  }

  table: {
    mode: rounded
    index_mode: always
    show_empty: true

    trim: {
      methodology: wrapping
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
  }

  explore: {
    help_banner: true
    exit_esc: true
    command_bar_text: '#C4C9C6'

    status_bar_background: {
      fg: '#1D1F21'
      bg: '#C4C9C6'
    }

    highlight: {
      bg: 'yellow'
      fg: 'black'
    }

    table: {
      split_line: '#404040'
      cursor: true
      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true
      show_head: true
      show_index: true
    }

    config: {
      cursor_color: {
        bg: 'yellow'
        fg: 'black'
      }
    }
  }

  history: {
    max_size: 1000
    sync_on_enter: true
    file_format: "plaintext"
  }

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"

    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }

  filesize: {
    metric: true
    format: "auto"
  }

  cursor_shape: {
    vi_insert: line
    vi_normal: underscore
  }

  color_config: $theme
  use_grid_icons: true
  footer_mode: "25"
  float_precision: 2
  use_ansi_coloring: true
  edit_mode: vi
  shell_integration: false
  render_right_prompt_on_last_line: true

  hooks: {
    display_output: { ||
      if (term size).columns >= 100 {
        table -e
      } else {
        table
      }
    }
  }

  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "

      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }

      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "

      type: {
        layout: list
        page_size: 10
      }

      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "

      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }

      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: commands_menu
      only_buffer_difference: false
      marker: "# "

      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }

      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }

      source: { |buffer, position|
        $nu.scope.commands
        | where name =~ $buffer
        | each { |it| {
          value: $it.name
          description: $it.usage
        } }
      }
    }
    {
      name: vars_menu
      only_buffer_difference: true
      marker: "# "

      type: {
        layout: list
        page_size: 10
      }

      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }

      source: { |buffer, position|
        nu.scope.vars
        | where name =~ $buffer
        | sort-by name
        | each { |it| {
          value: $it.name
          description: $it.type
        } }
      }
    }
    {
      name: commands_with_description
      only_buffer_difference: true
      marker: "# "

      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }

      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }

      source: { |buffer, position|
        $nu.scope.commands
        | where name =~ $buffer
        | each { |it| {
          value: $it.name
          description: $it.usage
        } }
      }
    }
  ]

  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: next_page
      modifier: control
      keycode: char_x
      mode: emacs
      event: { send: menupagenext }
    }
    {
      name: undo_or_previous_page
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
       }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          {edit: pastecutbufferafter}
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cutfromlinestart}
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cuttolineend}
        ]
      }
    }
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: alt
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}
