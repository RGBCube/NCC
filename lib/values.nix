lib: {
  normalUser = attributes: attributes // {
    isNormalUser = true;
  };

  sudoUser = attributes: attributes // {
    isNormalUser = true;
    extraGroups  = [ "wheel" ] ++ attributes.extraGroups or [];
  };

  desktopUser = attributes: attributes // {
    isNormalUser  = true;
    isDesktopUser = true; # Defined in options/desktop.nix.
  };

  systemUser = attributes: attributes // {
    isSystemUser = true;
  };
}
