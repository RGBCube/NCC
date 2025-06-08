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

def today []: nothing -> string {
  date now | format date "%Y-%m-%d"
}

# Create a directory and cd into it.
def --env mc [path: path]: nothing -> nothing {
  mkdir $path
  cd $path
}

# Create a directory, cd into it and initialize version control.
def --env mcg [path: path]: nothing -> nothing {
  mkdir $path
  cd $path
  jj git init --colocate
}

let site_path = glob "~" | path join "projects" "site"

# Edit a thought dump.
def "dump ed" [
  namespace: string # The thought dump to edit. Namespaced using '.', does not include file extension.
]: nothing -> nothing {
  let dump_path = $site_path | path join "site" "dump" ...($namespace | split row ".") | $in + ".md"

  mkdir ($dump_path | path parse | get parent)
  touch $dump_path

  let old_dump_hash = open $dump_path | hash sha256

  ^$env.EDITOR $dump_path

  let dump_size = ls $dump_path | get 0.size
  if $dump_size == 0b {
    print $"(ansi red)thought dump was emptied(ansi reset)"
    dump rm $namespace
  } else if $old_dump_hash == (open $dump_path | hash sha256) {
    print $"(ansi yellow)thought dump was not changed(ansi reset)"
  } else {
    print $"(ansi magenta)thought dump was edited(ansi reset)"
    print $"(ansi green)deploying...(ansi reset)"

    cd $site_path

    jj commit --message $"dump\(($namespace)\): update"
    jj bookmark set master --revision @-

    [
      { jj git push --remote origin }
      { jj git push --remote rad }
      { ./apply.nu }
    ] | par-each { do $in }

    cd -
  }
}

# Delete a thought dump.
def "dump rm" [
  namespace: string # The thought dump to edit. Namespaced using '.', does not include file extension.
]: nothing -> nothing {
  print $namespace
  let dump_path = $site_path | path join "site" "dump" ...($namespace | split row ".") | $in + ".md"
  let parent_path = $dump_path | path parse | get parent

  print $"(ansi red)deleting thought dump...(ansi reset)"
  rm $dump_path

  if (ls $parent_path | length) == 0 {
    print $"(ansi red)parent folder is empty, deleting that too...(ansi reset)"
    print $"(ansi yellow)other parents will not be deleted, if you want to delete those do it manually(ansi reset)"
    rm $parent_path
  }

  print $"(ansi green)deploying...(ansi reset)"

  cd $site_path
  ./apply.nu
  cd -
}
