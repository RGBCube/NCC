with import ./keys.nix;

{
  "acme.age".publicKeys                = [ cube ];
  "cube.password.age".publicKeys       = [ cube ];
  "cube.id.age".publicKeys             = [ rgbcube ];
  "enka.said.password.age".publicKeys  = [ rgbcube ];
  "enka.orhan.password.age".publicKeys = [ rgbcube ];
}
