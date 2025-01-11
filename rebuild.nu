#!/usr/bin/env nu

# Rebuild a NixOS / Darwin configuration.
def main --wrapped [
  host: string = "" # The host to build.
  ...arguments      # The arguments to pass to `nixos-rebuild switch`.
] {
  let host = if ($host | is-not-empty) {
    $host
  } else {
    (hostname)
  }

  let args_split = $arguments | split list "--"

  let nh_flags = [
    "--hostname" $host
  ] | append ($args_split | get --ignore-errors 0 | default [])

  let nix_flags = [
    "--option" "accept-flake-config" "true"
    "--option" "eval-cache"          "false"
  ] | append ($args_split | get --ignore-errors 1 | default [])

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

  if (uname | get kernel-name) == "Darwin" {
    darwin-rebuild switch --flake (".#" + $host) ...$nix_flags
  } else {
    nh os switch . ...$nh_flags -- ...$nix_flags
  }
}

