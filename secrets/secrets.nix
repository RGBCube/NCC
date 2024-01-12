with import ./keys.nix;

{
  "acme.age".publicKeys                     = [ cube ];
  "cube.password.hash.age".publicKeys       = [ cube ];
  "cube.mail.password.hash.age".publicKeys  = [ cube ];
  "cube.id.age".publicKeys                  = [ rgbcube ];
  "enka.said.password.hash.age".publicKeys  = [ rgbcube ];
  "enka.orhan.password.hash.age".publicKeys = [ rgbcube ];
}
