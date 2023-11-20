#!/usr/bin/env nu

def main [
  machine: string = "" # The machine to build.
] {
  mut machine_ = $machine

  let valid_machines = ls machines | where type == dir | get name | each { $in | str replace "machines/" "" }

  if ($machine_ | is-empty) {
    $machine_ = (input $"machine to build [($valid_machines | str join ', ')]: ")

    if ($machine_ | is-empty) and ($valid_machines | length) == 1 {
      $machine_ = ($valid_machines | get 0)
    } else {
      main ""
      exit
    }
  }

  if not ($machine_ in $valid_machines) {
    main ""
    exit
  }

  sudo --validate
  sh -c $"sudo nixos-rebuild switch --log-format internal-json --impure --flake ('.#' + $machine) |& nom --json"
}
