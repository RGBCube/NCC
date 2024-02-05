#!/usr/bin/env nu

def complete [] {
  ls hosts | get name | each { $in | str replace "hosts/" "" }
}

def main --wrapped [
  host: string@complete = "" # The host to build.
  ...arguments               # The arguments to pass to `nixos-rebuild switch`.
] {
  let flags = [
    $"--flake ('.#' + $host)"
    "--show-trace"
    "--option accept-flake-config true"
    "--log-format internal-json"
  ] | append $arguments

  if $host == (hostname) or $host == "" {
    sudo sh -c $"nixos-rebuild switch ($flags | str join ' ') |& nom --json"
  } else {
    git ls-files | rsync --rsh "ssh -q" --delete --files-from - ./ cube:Configuration

    ssh -q $host $"sh -c '
      cd Configuration
      nix flake archive
      sudo nixos-rebuild switch ($flags | str join ' ') |& nom --json
    '"
  }
}
