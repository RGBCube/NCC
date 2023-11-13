# My NixOS Configurations

This repository contains my NixOS configurations for all my machines.

## Bootstrapping

Here is the script you need to run to get this working:

> [!IMPORTANT]
> You **WILL NEED** `/etc/nixos/hardware-configuration.nix`, as this configuration
> imports it, so you will need to run `sudo nixos-generate-config` if you've deleted them.

```sh
nix-shell -p git --command "git clone https://github.com/RGBCube/NixOSConfiguration && cd NixOSConfiguration"

nix-shell -p nu --command "nu rebuild.nu"
```

`machine-name` is a machine selected from the machines in the `machines` directory.

## Applying Changes

Lets say you have changed the configuration and want to apply the changes
to your system. You would have to run the rebuild script:

```sh
./rebuild.nu
```

This runs the script interactively.

You can also check how the script is used:

```sh
./rebuild.sh --help
```

This outputs:

```
Usage:
  > rebuild.nu (machine) ...(arguments)

Flags:
  -h, --help - Display the help message for this command

Parameters:
  machine <string>: The machine to build. (optional, default: '')
  ...arguments <any>: Extra arguments to pass to nixos-rebuild.
```

## License

```
MIT License

Copyright (c) 2023-present RGBCube

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
