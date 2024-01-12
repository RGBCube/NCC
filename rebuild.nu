#!/usr/bin/env nu

def complete [] {
  ls hosts | get name | each { $in | str replace "hosts/" "" }
}

def main --wrapped [
  host: string@complete = "" # The host to build.
  ...arguments               # The arguments to pass to `nix system apply`.
] {
  let flags = [
    $"--flake ('.#' + $host)"
    "--option accept-flake-config true"
    "--log-format internal-json"
  ] | append $arguments

  sudo sh -c $"nixos-rebuild switch ($flags | str join ' ') |& nom --json"
}
