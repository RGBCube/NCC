$env.PROMPT_INDICATOR           = "";
$env.PROMPT_INDICATOR_VI_INSERT = "";
$env.PROMPT_INDICATOR_VI_NORMAL = "";
$env.PROMPT_MULTILINE_INDICATOR = "";

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}
