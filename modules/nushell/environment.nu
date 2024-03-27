$env.ENV_CONVERSIONS.PATH = {
  from_string: {|string|
    $string | split row (char esep) | path expand --no-symlink
  }
  to_string: {|value|
    $value | path expand --no-symlink | str join (char esep)
  }
}

def --env mc [path: path] {
  mkdir $path
  cd $path
}

def --env mcg [path: path] {
  mkdir $path
  cd $path
  git init
}

zoxide init nushell --cmd cd | save --force ~/.config/nushell/zoxide.nu
