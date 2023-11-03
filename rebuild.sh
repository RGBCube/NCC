#!/bin/sh

if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $0 [-h | --help] [-c | --clean-garbage] [machine]"
    exit
fi

machine=
if [[ $1 != "" ]]; then
  if [[ $1 != "-c" && $1 != "--clean-garbage" ]]; then
    # Use the first argument if it exists and is not clean-garbage.
    machine=$1
  elif [[ $2 != "" ]]; then
    # Use the second argument if the first argument is clean-garbage and the second argument exists.
    machine=$2
  fi
fi

if [[ $machine == "" ]]; then
  available_machines=$(ls --format=commas machines)
  read -p "What machine would you like to build? (Possible options: $available_machines): " machine
fi

if [[ $1 == "-c" || $1 == "--clean-garbage" ]]; then
  clean_garbage=Y
else
  read -p "Clean garbage? [y/N]: " clean_garbage
fi

nix-shell --packages git --command "sudo nixos-rebuild switch --flake .#$machine" || exit 1

if [[ $clean_garbage =~ ^[Yy]$ ]]; then
    sudo nix-collect-garbage --delete-old
fi
