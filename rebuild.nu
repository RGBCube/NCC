#!/usr/bin/env nu

# Rebuild a NixOS / Darwin config.
def main --wrapped [
  host: string = "" # The host to build.
  ...arguments      # The arguments to pass to `nixos-rebuild switch`.
]: nothing -> nothing {
  let host = if ($host | is-not-empty) {
    $host
  } else {
    (hostname)
  }

  if $host != (hostname) {
    git ls-files
    | (rsync
      --rsh "ssh -q"
      --delete-missing-args
      --compress
      --files-from -
      ./ ($host + ":ncc"))

    ssh -q -tt $host $"
      cd ncc
      ./rebuild.nu ($host) ($arguments | str join ' ')
    "

    return
  }

  let args_split = $arguments | prepend "" | split list "--"
  let nh_flags = [
    "--hostname" $host
  ] | append ($args_split | get 0 | filter { $in != "" })

  let nix_flags = [
    "--option" "accept-flake-config" "true"
    "--option" "eval-cache"          "false"
  ] | append ($args_split | get --ignore-errors 1 | default [])

  if (uname | get kernel-name) == "Darwin" {
    darwin-rebuild switch --flake (".#" + $host) ...$nix_flags

    if not (xcode-select --install e>| str contains "Command line tools are already installed") {
      darwin-shadow-xcode-popup
    }

    darwin-set-zshrc
  } else {
    nh os switch . ...$nh_flags -- ...$nix_flags
  }
}

# Replace with the command that has been triggering
# the "install developer tools" popup.
#
# Set by default to "SplitForks" because who even uses that?
const original_trigger = "/usr/bin/SplitForks"

# Where the symbolic links to `/usr/bin/false` will
# be created in to shadow all popup-triggering binaries.
#
# Place this in your $env.PATH right before /usr/bin
# to never get the "install developer tools" popup ever again:
#
# ```nu
# let usr_bin_index = $env.PATH
# | enumerate
# | where item == /usr/bin
# | get 0.index
#
# $env.PATH = $env.PATH | insert $usr_bin_index $shadow_path
# ```
#
# Do NOT set this to a path that you use for other things,
# it will get deleted if it exists to only have the shadowers.
const shadow_path = "~/.local/shadow" | path expand # Did you read the comment?

def darwin-shadow-xcode-popup [] {
  print "shadowing xcode popup binaries..."

  let original_size = ls $original_trigger | get 0.size

  let shadoweds = ls /usr/bin
  | flatten
  | filter {
    # All xcode-select binaries are the same size, so we can narrow down and not run weird stuff.
    $in.size == $original_size
  }
  | filter {
    ^$in.name e>| str contains "xcode-select: note: No developer tools were found, requesting install."
  }
  | get name
  | each { path basename }

  rm -rf $shadow_path
  mkdir $shadow_path

  for shadowed in $shadoweds {
    let shadow_path = $shadow_path | path join $shadowed

    ln --symbolic /usr/bin/false $shadow_path
  }
}

def darwin-set-zshrc [] {
  print "setting zshrc..."

  let nu_command = $"
    let usr_bin_index = $env.PATH
    | enumerate
    | where item == /usr/bin
    | get 0.index

    $env.PATH = $env.PATH | insert $usr_bin_index ($shadow_path | path expand)

    $env.SHELL = which nu | get 0.path
  "

  let zshrc = $"
    exec nu --execute '
      ($nu_command)
    '
  "

  $zshrc | save --force ~/.zshrc
}
