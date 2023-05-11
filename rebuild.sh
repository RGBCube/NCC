#!/bin/sh

if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $0 [-h | --help] [-c | --clean-garbage] [machine]"
    exit
fi

if [[ $1 != "" ]]; then
  if [[ $1 != "-c" && $1 != "--clean-garbage" ]]; then
    machine=$1
  elif [[ $2 != "" ]]; then
    machine=$2
  else
    read -p "What machine would you want to build? [$(ls --format=commas machines)]: " machine
  fi
else
  read -p "What machine would you want to build? [$(ls --format=commas machines)]: " machine
fi

sudo true

sed -i.old "s|@pwd@|$PWD|g" flake.nix

sudo nixos-rebuild switch --impure --flake .#$machine
if [[ $? != 0 ]]; then
    exit 1
fi

mv -f flake.nix.old flake.nix

if [[ $1 != "-c" && $1 != "--clean-garbage" ]]; then
    read -p "Clean garbage? [Y/N]: " clean_garbage

    if [[ $clean_garbage =~ ^[Yy]$ ]]; then
        sudo nix-collect-garbage -d
    fi
else
    sudo nix-collect-garbage -d
fi
