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
    "--show-trace"
    "--option accept-flake-config true"
    "--log-format internal-json"
  ] | append $arguments

  if $host == (hostname) or $host == "" {
    sudo sh -c $"nixos-rebuild switch ($flags | str join ' ') |& nom --json"
  } else {
    git ls-files | tar -cf - --files-from - | zstd -c3 | save --force /tmp/config.tar.zst
    scp -q /tmp/config.tar.zst ($host + ':/tmp/')

    ssh -q $host $"
      rm -rf /tmp/config
      mkdir /tmp/config
      cd /tmp/config
      tar -xf /tmp/config.tar.zst

      sh -c 'sudo nixos-rebuild switch ($flags | str join ' ') |& nom --json'
    "
  }
}
