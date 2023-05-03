#!/bin/sh

sudo true

echo "* Cleaning /etc/nixos"
sudo rm -rf /etc/nixos
sudo mkdir /etc/nixos

echo "* Linking files"
sudo ln ./flake.nix /etc/nixos/flake.nix
sudo ln ./flake.lock /etc/nixos/flake.lock

sudo ln -s ./system-configuration /etc/nixos/
sudo ln -s ./home-configuration /etc/nixos/
