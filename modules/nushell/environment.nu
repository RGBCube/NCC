$env.ENV_CONVERSIONS.PATH = {
  from_string: {|string|
    $string | split row (char esep) | path expand --no-symlink
  }
  to_string: {|value|
    $value | path expand --no-symlink | str join (char esep)
  }
}

$env.LS_COLORS = (open ~/.config/nushell/ls_colors.txt)

def --env mc [path: path] {
  mkdir $path
  cd $path
}

def --env mcg [path: path] {
  mkdir $path
  cd $path
  git init
}

source ~/.config/nushell/zoxide.nu
