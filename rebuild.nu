#!/usr/bin/env nu

def main [
  machine: string = "" # The machine to build.
  ...arguments         # Extra arguments to pass to nixos-rebuild.
] {
  mut machine_ = $machine

  let valid_machines = ls machines | where type == dir | get name | each { $in | str replace "machines/" "" }

  if ($machine_ | is-empty) {
    $machine_ = (input $"machine to build [($valid_machines | str join ', ')]: ")

    if ($machine_ | is-empty) and ($valid_machines | length) == 1 {
      $machine_ = ($valid_machines | get 0)
    } else {
      main "" ($arguments | str join " ")
      exit
    }
  }

  if not ($machine_ in $valid_machines) {
    main "" ($arguments | str join " ")
    exit
  }

  sudo nixos-rebuild switch --log-format internal-json --impure --flake (".#" + $machine) ($arguments | str join ' ') | nom --json
}
