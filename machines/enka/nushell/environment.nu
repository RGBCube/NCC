$env.PROMPT_INDICATOR           = "";
$env.PROMPT_INDICATOR_VI_INSERT = "";
$env.PROMPT_INDICATOR_VI_NORMAL = "";
$env.PROMPT_MULTILINE_INDICATOR = "";

$env.ENV_CONVERSIONS.PATH = {
    from_string: {|string|
        $string | split row (char esep) | path expand --no-symlink
    }
    to_string: {|value|
        $value | path expand --no-symlink | str join (char esep)
    }
}

def hx [...arguments] {
    kitty @ set-spacing padding=0

    ^hx $arguments

    kitty @ set-spacing padding=10
}
