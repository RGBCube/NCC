#!/usr/bin/env nu

def complete [] {
  ls machines | get name | each { $in | str replace "machines/" "" }
}

def main --wrapped [
  machine: string@complete = "" # The machine to build.
  ...arguments
] {
  let flags = $arguments | append [
    "--option accept-flake-config true"
    "--log-format internal-json"
    "--impure"
  ]

  sudo sh -c $"nix system apply ('.#' + $machine) ($flags | str join ' ') |& nom --json"
}
