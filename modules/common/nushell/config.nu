$env.config = {
  bracketed_paste:                  true
  buffer_editor:                    ""
  datetime_format:                  {}
  edit_mode:                        vi
  error_style:                      fancy
  float_precision:                  2
  footer_mode:                      25
  render_right_prompt_on_last_line: false
  show_banner:                      false
  use_ansi_coloring:                true
  use_kitty_protocol:               true

  shell_integration: {
    osc2:                   false
    osc7:                   true
    osc8:                   true
    osc9_9:                 false
    osc133:                 true
    osc633:                 true
    reset_application_mode: true
  }
}

$env.config.color_config = {
  binary:        white
  block:         white
  bool:          {|| if $in { "light_green" } else { "light_red" } }
  cell-path:     white
  date:          purple
  duration:      white
  empty:         blue
  filesize:      cyan
  float:         white
  header:        green_bold
  hints:         dark_gray
  int:           white
  list:          white
  nothing:       white
  range:         white
  record:        white
  row_index:     green_bold
  search_result: { bg: red fg: white }
  separator:     white
  string:        {|| if $in =~ "^(#|0x)[a-fA-F0-9]+$" { ($in | str replace "0x" "#") } else { "white" } }
  leading_trailing_space_bg: { attr: n }

  shape_and:           purple_bold
  shape_binary:        purple_bold
  shape_block:         blue_bold
  shape_bool:          light_cyan
  shape_closure:       green_bold
  shape_custom:        green
  shape_datetime:      cyan_bold
  shape_directory:     cyan
  shape_external:      cyan
  shape_externalarg:   green_bold
  shape_filepath:      cyan
  shape_flag:          blue_bold
  shape_float:         purple_bold
  shape_garbage:       { fg: white bg: red attr: b}
  shape_globpattern:   cyan_bold
  shape_int:           purple_bold
  shape_internalcall:  cyan_bold
  shape_list:          cyan_bold
  shape_literal:       blue
  shape_match_pattern: green
  shape_nothing:       light_cyan
  shape_operator:      yellow
  shape_or:            purple_bold
  shape_pipe:          purple_bold
  shape_range:         yellow_bold
  shape_record:        cyan_bold
  shape_redirection:   purple_bold
  shape_signature:     green_bold
  shape_string:        green
  shape_table:         blue_bold
  shape_vardecl:       purple
  shape_variable:      purple
  shape_matching_brackets:    { attr: u }
  shape_string_interpolation: cyan_bold
}

$env.config.ls = {
  clickable_links: true
  use_ls_colors: true
}

$env.config.rm.always_trash = false

$env.config.table = {
  header_on_separator: false
  index_mode: always
  mode:       rounded
  padding:    { left: 1 right: 1 }
  show_empty: true
  trim: {
    methodology:             wrapping
    wrapping_try_keep_words: true
    truncating_suffix:       "..."
  }
}

$env.config.explore = {
  command_bar_text: { fg: "#C4C9C6" }
  highlight:        { fg: black bg: yellow }
  status: {
    error: { fg: white bg: red }
    warn:  {}
    info:  {}
  }
  status_bar_background: { fg: "#1D1F21" bg: "#C4C9C6" }
  table: {
    split_line:      { fg: "#404040" }
    selected_cell:   { bg: light_blue }
    selected_row:    {}
    selected_column: {}
  }
}

$env.config.history = {
  file_format:   sqlite
  isolation:     false
  max_size:      100_000
  sync_on_enter: true
}

$env.config.completions = {
  algorithm:      prefix
  case_sensitive: false
  partial:        true
  quick:          true
  external: {
    enable:      true
    max_results: 100
    completer:   {|tokens: list<string>|
      let expanded = scope aliases | where name == $tokens.0 | get --ignore-errors expansion.0

      mut expanded_tokens = if $expanded != null and $tokens.0 != "cd" {
        $expanded | split row " " | append ($tokens | skip 1)
      } else {
        $tokens
      }

      $expanded_tokens.0 = ($expanded_tokens.0 | str trim --left --char "^")

      fish --command $"complete '--do-complete=($expanded_tokens | str join ' ')'"
      | $"value(char tab)description(char newline)" + $in
      | from tsv --flexible --no-infer
    }
  }
}

$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}

$env.config.hooks = {
  command_not_found: {||}

  display_output: {
    tee { table --expand | print }
    | $env.last = $in
  }

  env_change: {}

  pre_execution: [
    {
      let prompt = commandline | str trim

      if ($prompt | is-empty) {
        return
      }

      print $"(ansi title)($prompt) — nu(char bel)"
    }
  ]

  pre_prompt: []
}

# Retrieve the output of the last command.
def _ []: nothing -> any {
  $env.last
}

$env.config.menus = [
  {
    marker:                 "| "
    name:                   completion_menu
    only_buffer_difference: false
    style: {
      description_text: yellow
      selected_text:    green_reverse
      text:             green
    }
    type: {
      col_padding: 2
      col_width:   20
      columns:     4
      layout:      columnar
    }
  }
  {
    marker:                 "? "
    name:                   history_menu
    only_buffer_difference: true
    style: {
      description_text: yellow
      selected_text:    green_reverse
      text:             green
    }
    type: {
      layout:    list
      page_size: 10
    }
  }
  {
    marker:                 "? "
    name:                   help_menu
    only_buffer_difference: true
    style: {
      description_text: yellow
      selected_text:    green_reverse
      text:             green
    }
    type: {
      col_padding:      2
      col_width:        20
      columns:          4
      description_rows: 10
      layout:           description
      selection_rows:   4
    }
  }
]

$env.config.keybindings = [
  {
    name: copy_commandline
    modifier: alt
    keycode: char_c
    mode: [ vi_normal vi_insert ]
    event: {
      send: executehostcommand
      cmd: 'commandline | nu-highlight | $"```ansi\n($in)\n```" | copy'
    }
  }
  {
    name:     completion_menu
    modifier: none
    keycode:  tab
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: menu name: completion_menu }
        { send: menunext }
        { edit: complete }
      ]
    }
  }
  {
    name:     history_menu
    modifier: control
    keycode:  char_h
    mode:     [ vi_insert vi_normal ]
    event:    { send: menu name: history_menu }
  }
  {
    name:     escape
    modifier: none
    keycode:  escape
    mode:     [ vi_normal vi_insert ]
    event:    { send: esc }
  }
  {
    name:     cancel_command
    modifier: control
    keycode:  char_c
    mode:     [ vi_normal vi_insert ]
    event:    { send: ctrlc }
  }
  {
    name:     quit_shell
    modifier: control
    keycode:  char_d
    mode:     [ vi_normal vi_insert ]
    event:    { send: ctrld }
  }
  {
    name:     clear_screen
    modifier: control
    keycode:  char_l
    mode:     [ vi_normal vi_insert ]
    event:    { send: clearscreen }
  }
  {
    name:     open_command_editor
    modifier: control
    keycode:  char_o
    mode:     [ vi_normal vi_insert ]
    event:    { send: openeditor }
  }
  {
    name:     abbr
    modifier: control
    keycode:  space
    mode:     [ vi_normal vi_insert ]
    event: [
      { send: menu name: abbr_menu }
      { edit: insertchar, value: " " }
    ]
  }
  {
    name:     move_up
    modifier: none
    keycode:  up
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: menuup }
        { send: up }
      ]
    }
  }
  {
    name:     move_down
    modifier: none
    keycode:  down
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: menudown }
        { send: down }
      ]
    }
  }
  {
    name:     move_left
    modifier: none
    keycode:  left
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: menuleft }
        { send: left }
      ]
    }
  }
  {
    name:     move_right_or_take_history_hint
    modifier: none
    keycode:  right
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: historyhintcomplete }
        { send: menuright }
        { send: right }
      ]
    }
  }
  {
    name:     move_one_word_left
    modifier: control
    keycode:  left
    mode:     [ vi_normal vi_insert ]
    event:    { edit: movewordleft }
  }
  {
    name:     move_one_word_right_or_take_history_hint
    modifier: control
    keycode:  right
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: historyhintwordcomplete }
        { edit: movewordright }
      ]
    }
  }
  {
    name:     move_to_line_start
    modifier: control
    keycode:  char_a
    mode:     [ vi_normal vi_insert ]
    event:    { edit: movetolinestart }
  }
  {
    name:     move_to_line_end_or_take_history_hint
    modifier: control
    keycode:  char_e
    mode:     [ vi_normal vi_insert ]
    event:    {
      until: [
        { send: historyhintcomplete }
        { edit: movetolineend }
      ]
    }
  }
  {
    name:     delete_one_character_backward
    modifier: none
    keycode:  backspace
    mode:     vi_insert
    event:    { edit: backspace }
  }
  {
    name:     delete_one_word_backward
    modifier: control
    keycode:  backspace
    mode:     vi_insert
    event:    { edit: backspaceword }
  }
  {
    name:     newline_or_run_command
    modifier: none
    keycode:  enter
    mode:     vi_insert
    event:    { send: enter }
  }
]

$env.LS_COLORS = (open ~/.config/nushell/ls_colors.txt)
source ~/.config/nushell/zoxide.nu

source ~/.config/nushell/starship.nu
