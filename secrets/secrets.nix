let
  keys = import ./keys.nix;
in {
  "acme.age".publicKeys                = [ keys.cube ];
  "cube.password.age".publicKeys       = [ keys.cube ];
  "enka.said.password.age".publicKeys  = [ keys.rgbcube ];
  "enka.orhan.password.age".publicKeys = [ keys.rgbcube ];
}
