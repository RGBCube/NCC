#!/bin/sh

if [[ "$1" = "--help" ]] || [[ "$1" = "-h" ]]; then
    echo "Usage: rebuild.sh [-h | --help] [-c | --clean-garbage] [machine]"
    exit
fi

sudo true

if [[ -n "$1" ]]; then
  machine = $1
else
  read -p "What machine would you want to build? [$(ls --format=commas machines)]: " machine
fi

echo -e "\n*** REBUILDING SYSTEM ***\n"
sudo nixos-rebuild switch --flake .#$machine

if [[ $? != 0 ]]; then
    exit 1
fi

if [[ $1 != "-c" && $1 != "--clean-garbage" ]]; then
    read -p "Clean garbage? [Y/N]: " clean_garbage

    if [[ $clean_garbage =~ ^[Yy]$ ]]; then
        nix-collect-garbage -d
    fi
else
    nix-collect-garbage -d
fi
