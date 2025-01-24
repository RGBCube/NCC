$env.ENV_CONVERSIONS.PATH = {
  from_string: {|string|
    $string | split row (char esep) | path expand --no-symlink
  }
  to_string: {|value|
    $value | path expand --no-symlink | str join (char esep)
  }
}

def copy []: string -> nothing {
	print --no-newline $"(ansi osc)52;c;($in | encode base64)(ansi st)"
}

def --env mc [path: path]: nothing -> nothing {
  mkdir $path
  cd $path
}

def --env mcg [path: path]: nothing -> nothing {
  mkdir $path
  cd $path
  git init
}
