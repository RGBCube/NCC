let theme = {
    separator:                  white
    leading_trailing_space_bg:  { attr: n }
    header:                     green_bold
    empty:                      blue
    bool:                       {|| if $in { "light_cyan" } else { "light_red" }}
    int:                        white
    filesize:                   cyan
    duration:                   white
    date:                       purple
    range:                      white
    float:                      white
    string:                     white
    nothing:                    white
    binary:                     white
    cell-path:                  white
    row_index:                  green_bold
    record:                     white
    list:                       white
    block:                      white
    hints:                      dark_gray
    search_result:              { bg: red fg: white }

    shape_and:                  purple_bold
    shape_binary:               purple_bold
    shape_block:                blue_bold
    shape_bool:                 light_cyan
    shape_closure:              green_bold
    shape_custom:               green
    shape_datetime:             cyan_bold
    shape_directory:            cyan
    shape_external:             cyan
    shape_externalarg:          green_bold
    shape_filepath:             cyan
    shape_flag:                 blue_bold
    shape_float:                purple_bold
    shape_garbage:              { fg: white bg: red attr: b}
    shape_globpattern:          cyan_bold
    shape_int:                  purple_bold
    shape_internalcall:         cyan_bold
    shape_list:                 cyan_bold
    shape_literal:              blue
    shape_match_pattern:        green
    shape_matching_brackets:    { attr: u }
    shape_nothing:              light_cyan
    shape_operator:             yellow
    shape_or:                   purple_bold
    shape_pipe:                 purple_bold
    shape_range:                yellow_bold
    shape_record:               cyan_bold
    shape_redirection:          purple_bold
    shape_signature:            green_bold
    shape_string:               green
    shape_string_interpolation: cyan_bold
    shape_table:                blue_bold
    shape_variable:             purple
    shape_vardecl:              purple
}

$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: false
    }

    table: {
        mode:       basic
        index_mode: always
        show_empty: true
        padding:    { left: 1, right: 1 }
        trim: {
            methodology:             wrapping
            wrapping_try_keep_words: true
            truncating_suffix:       "..."
        }
        header_on_separator: false
    }

    error_style: "fancy"

    datetime_format: {}

    explore: {
        status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" }
        command_bar_text:      { fg: "#C4C9C6" }
        highlight:             { fg: black, bg: yellow }
        status: {
            error: { fg: white, bg: red }
            warn:  {}
            info:  {}
        },
        table: {
            split_line:      { fg: "#404040" }
            selected_cell:   { bg: light_blue }
            selected_row:    {}
            selected_column: {}
        },
    }

    history: {
        max_size:      100_000
        sync_on_enter: true
        file_format:   plaintext
        isolation:     false
    }

    completions: {
        case_sensitive: false
        quick:          true
        partial:        true
        algorithm:      prefix
        external: {
            enable:      true
            max_results: 100
            completer:   {|tokens|
                let expanded_alias = scope aliases | where name == $tokens.0 | get --ignore-errors expansion.0

                let tokens = if $expanded_alias != null  {
                    $expanded_alias | split row " " | append ($tokens | skip 1)
                } else {
                    $tokens
                }

                let cmd = $tokens.0 | str trim --left --char "^"

                let completions = ^carapace $cmd nushell $tokens | from json | default []

                if ($completions | is-empty) {
                    let path = $tokens | last
                    ls $"($path)*" | each {|it|
                        let choice = if ($path | str ends-with "/") {
                            $path | path join ($it.name | path basename)
                        } else {
                            $path | path dirname | path join ($it.name | path basename)
                        }
                        
                        let choice = if ($it.type == "dir") and (not ($choice | str ends-with "/")) {
                            $"($choice)/"
                        } else {
                            $choice
                        }

                        if ($choice | str contains " ") {
                            $"`($choice)`"
                        } else {
                            $choice
                        }
                    }
                } else if ($completions | where value =~ "^.*ERR$" | is-empty) {
                    $completions
                } else {
                    null
                }
            }
        }
    }

    filesize: {
        metric: true
        format: auto
    }

    cursor_shape: {
        emacs:     line
        vi_insert: blink_underscore
        vi_normal: block
    }

    color_config:                     $theme
    use_grid_icons:                   true
    footer_mode:                      25
    float_precision:                  2
    buffer_editor:                    ""
    use_ansi_coloring:                true
    bracketed_paste:                  true
    edit_mode:                        vi
    shell_integration:                false
    render_right_prompt_on_last_line: false
    use_kitty_protocol:               false

    hooks: {
        pre_prompt:        []
        pre_execution:     []
        env_change:        {}
        display_output:    "if (term size).columns >= 100 { table --expand } else { table }"
        command_not_found: {}
    }

    menus: [
        {
            name:                   completion_menu
            only_buffer_difference: false
            marker:                 "| "
            type: {
                layout:      columnar
                columns:     4
                col_width:   20
                col_padding: 2
            }
            style: {
                text:             green
                selected_text:    green_reverse
                description_text: yellow
            }
        }
        {
            name:                   history_menu
            only_buffer_difference: true
            marker:                 "? "
            type: {
                layout:    list
                page_size: 10
            }
            style: {
                text:             green
                selected_text:    green_reverse
                description_text: yellow
            }
        }
        {
            name:                   help_menu
            only_buffer_difference: true
            marker:                 "? "
            type: {
                layout:           description
                columns:          4
                col_width:        20
                col_padding:      2
                selection_rows:   4
                description_rows: 10
            }
            style: {
                text:             green
                selected_text:    green_reverse
                description_text: yellow
            }
        }
    ]

    keybindings: [
        {
            name:     completion_menu
            modifier: none
            keycode:  tab
            mode:     [ emacs vi_normal vi_insert ]
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
            keycode:  char_r
            mode:     [ emacs, vi_insert, vi_normal ]
            event:    { send: menu name: history_menu }
        }
        {
            name:     help_menu
            modifier: none
            keycode:  f1
            mode:     [ emacs, vi_insert, vi_normal ]
            event:    { send: menu name: help_menu }
        }
        {
            name:     completion_previous_menu
            modifier: shift
            keycode:  backtab
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: menuprevious }
        }
        {
            name:     next_page_menu
            modifier: control
            keycode:  char_x
            mode:     emacs
            event:    { send: menupagenext }
        }
        {
            name:     undo_or_previous_page_menu
            modifier: control
            keycode:  char_z
            mode:     emacs
            event:    {
                until: [
                    { send: menupageprevious }
                    { edit: undo }
                ]
            }
        }
        {
            name:     escape
            modifier: none
            keycode:  escape
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: esc }
        }
        {
            name:     cancel_command
            modifier: control
            keycode:  char_c
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: ctrlc }
        }
        {
            name:     quit_shell
            modifier: control
            keycode:  char_d
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: ctrld }
        }
        {
            name:     clear_screen
            modifier: control
            keycode:  char_l
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: clearscreen }
        }
        {
            name:     search_history
            modifier: control
            keycode:  char_q
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: searchhistory }
        }
        {
            name:     open_command_editor
            modifier: control
            keycode:  char_o
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { send: openeditor }
        }
        {
            name:     move_up
            modifier: none
            keycode:  up
            mode:     [ emacs, vi_normal, vi_insert ]
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
            mode:     [ emacs, vi_normal, vi_insert ]
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
            mode:     [ emacs, vi_normal, vi_insert ]
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
            mode:     [ emacs, vi_normal, vi_insert ]
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
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { edit: movewordleft }
        }
        {
            name:     move_one_word_right_or_take_history_hint
            modifier: control
            keycode:  right
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    {
                until: [
                    { send: historyhintwordcomplete }
                    { edit: movewordright }
                ]
            }
        }
        {
            name:     move_to_line_start
            modifier: none
            keycode:  home
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { edit: movetolinestart }
        }
        {
            name:     move_to_line_start
            modifier: control
            keycode:  char_a
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { edit: movetolinestart }
        }
        {
            name:     move_to_line_end_or_take_history_hint
            modifier: none
            keycode:  end
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    {
                until: [
                    { send: historyhintcomplete }
                    { edit: movetolineend }
                ]
            }
        }
        {
            name:     move_to_line_end_or_take_history_hint
            modifier: control
            keycode:  char_e
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    {
                until: [
                    { send: historyhintcomplete }
                    { edit: movetolineend }
                ]
            }
        }
        {
            name:     move_to_line_start
            modifier: control
            keycode:  home
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { edit: movetolinestart }
        }
        {
            name:     move_to_line_end
            modifier: control
            keycode:  end
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    { edit: movetolineend }
        }
        {
            name:     move_up
            modifier: control
            keycode:  char_p
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    {
                until: [
                    { send: menuup }
                    { send: up }
                ]
            }
        }
        {
            name:     move_down
            modifier: control
            keycode:  char_t
            mode:     [ emacs, vi_normal, vi_insert ]
            event:    {
                until: [
                    { send: menudown }
                    { send: down }
                ]
            }
        }
        {
            name:     delete_one_character_backward
            modifier: none
            keycode:  backspace
            mode:     [ emacs, vi_insert ]
            event:    { edit: backspace }
        }
        {
            name:     delete_one_word_backward
            modifier: control
            keycode:  backspace
            mode:     [ emacs, vi_insert ]
            event:    { edit: backspaceword }
        }
        {
            name:     delete_one_character_forward
            modifier: none
            keycode:  delete
            mode:     [ emacs, vi_insert ]
            event:    { edit: delete }
        }
        {
            name:     delete_one_character_forward
            modifier: control
            keycode:  delete
            mode:     [ emacs, vi_insert ]
            event:    { edit: delete }
        }
        {
            name:     delete_one_character_forward
            modifier: control
            keycode:  char_h
            mode:     [ emacs, vi_insert ]
            event:    { edit: backspace }
        }
        {
            name:     delete_one_word_backward
            modifier: control
            keycode:  char_w
            mode:     [ emacs, vi_insert ]
            event:    { edit: backspaceword }
        }
        {
            name:     move_left
            modifier: none
            keycode:  backspace
            mode:     v i_norma l
            event:    { edit: moveleft }
        }
        {
            name:     newline_or_run_command
            modifier: none
            keycode:  enter
            mode:     emacs
            event:    { send: enter }
        }
        {
            name:     move_left
            modifier: control
            keycode:  char_b
            mode:     emacs
            event:    {
                until: [
                    { send: menuleft }
                    { send: left }
                ]
            }
        }
        {
            name:     move_right_or_take_history_hint
            modifier: control
            keycode:  char_f
            mode:     emacs
            event:    {
                until: [
                    { send: historyhintcomplete }
                    { send: menuright }
                    { send: right }
                ]
            }
        }
        {
            name:     redo_change
            modifier: control
            keycode:  char_g
            mode:     emacs
            event:    { edit: redo }
        }
        {
            name:     undo_change
            modifier: control
            keycode:  char_z
            mode:     emacs
            event:    { edit: undo }
        }
        {
            name:     paste_before
            modifier: control
            keycode:  char_y
            mode:     emacs
            event:    { edit: pastecutbufferbefore }
        }
        {
            name:     cut_word_left
            modifier: control
            keycode:  char_w
            mode:     emacs
            event:    { edit: cutwordleft }
        }
        {
            name:     cut_line_to_end
            modifier: control
            keycode:  char_k
            mode:     emacs
            event:    { edit: cuttoend }
        }
        {
            name:     cut_line_from_start
            modifier: control
            keycode:  char_u
            mode:     emacs
            event:    { edit: cutfromstart }
        }
        {
            name:     swap_graphemes
            modifier: control
            keycode:  char_t
            mode:     emacs
            event:    { edit: swapgraphemes }
        }
        {
            name:     move_one_word_left
            modifier: alt
            keycode:  left
            mode:     emacs
            event:    { edit: movewordleft }
        }
        {
            name:     move_one_word_right_or_take_history_hint
            modifier: alt
            keycode:  right
            mode:     emacs
            event:    {
                until: [
                    { send: historyhintwordcomplete }
                    { edit: movewordright }
                ]
            }
        }
        {
            name:     move_one_word_left
            modifier: alt
            keycode:  char_b
            mode:     emacs
            event:    { edit: movewordleft }
        }
        {
            name:     move_one_word_right_or_take_history_hint
            modifier: alt
            keycode:  char_f
            mode:     emacs
            event:    {
                until: [
                    { send: historyhintwordcomplete }
                    { edit: movewordright }
                ]
            }
        }
        {
            name:     delete_one_word_forward
            modifier: alt
            keycode:  delete
            mode:     emacs
            event:    { edit: deleteword }
        }
        {
            name:     delete_one_word_backward
            modifier: alt
            keycode:  backspace
            mode:     emacs
            event:    { edit: backspaceword }
        }
        {
            name:     delete_one_word_backward
            modifier: alt
            keycode:  char_m
            mode:     emacs
            event:    { edit: backspaceword }
        }
        {
            name:     cut_word_to_right
            modifier: alt
            keycode:  char_d
            mode:     emacs
            event:    { edit: cutwordright }
        }
        {
            name:     upper_case_word
            modifier: alt
            keycode:  char_u
            mode:     emacs
            event:    { edit: uppercaseword }
        }
        {
            name:     lower_case_word
            modifier: alt
            keycode:  char_l
            mode:     emacs
            event:    { edit: lowercaseword }
        }
        {
            name:     capitalize_char
            modifier: alt
            keycode:  char_c
            mode:     emacs
            event:    { edit: capitalizechar }
        }
    ]
}
