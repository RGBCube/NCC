# My NixOS Configurations

This repository contains my NixOS configurations for all my machines.

## Bootstrapping

Here is the script you need to run to get this working:

> [!IMPORTANT]
> You will need to have an SSH key to authorize GitHub with,
> and have access to the Ghostty GitHub repository as I
> use Ghostty and Ghostty is in private beta at the moment.

```sh
sudo nix-shell --packages git nu nix-output-monitor --command "
  git clone https://github.com/RGBCube/NixOSConfiguration ~/Configuration
  cd ~/Configuration
  nu rebuild.nu <host>
"
```

`host` is a host selected from the hosts in the `hosts` directory.

## Applying Changes

Lets say you have changed the configuration and want to apply the changes
to your system. You would have to run the rebuild script:

```sh
./rebuild.nu
```

This runs the script interactively.

You can also check how the script is used by reading the parameters it takes.

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
