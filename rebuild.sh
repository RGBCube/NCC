#!/bin/sh

if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $0 [-h | --help] [machine]"
    exit
fi

machine=$1

if [[ $machine == "" ]]; then
  available_machines=$(ls --format=commas machines)
  read -p "What machine would you like to build? (Possible options: $available_machines): " machine
fi

nix-shell --packages git --command "sudo nixos-rebuild switch --flake .#$machine"
