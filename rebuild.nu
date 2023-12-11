#!/usr/bin/env nu

def complete [] {
  ls machines | get name | each { $in | str replace "machines/" "" }
}

def main --wrapped [
  machine: string@complete = "" # The machine to build.
  ...arguments                  # The arguments to pass to `nix system apply`.
] {
  let flags = [
    $"--flake ('.#' + $machine)"
    "--option accept-flake-config true"
    "--log-format internal-json"
  ] | append $arguments

  sudo sh -c $"nixos-rebuild switch ($flags | str join ' ') |& nom --json"
}
