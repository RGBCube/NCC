{
  system.defaults.NSGlobalDomain = {
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;

    "com.apple.springing.enabled" = true;
    "com.apple.springing.delay"   = 0.0;
  };

  system.defaults.CustomSystemPreferences."com.apple.desktopservices" = {
    DSDontWriteNetworkStores = true;
    DSDontWriteUSBStores     = true;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles      = true;

    FXEnableExtensionChangeWarning = true;
    FXPreferredViewStyle           = "Nlsv"; # List style.
    FXRemoveOldTrashItems          = true;

    _FXShowPosixPathInTitle      = true;
    _FXSortFoldersFirst          = true;
    _FXSortFoldersFirstOnDesktop = false;

    NewWindowTarget = "Home";

    ShowExternalHardDrivesOnDesktop = true;
    ShowMountedServersOnDesktop     = true;
    ShowPathbar                     = true;
    ShowRemovableMediaOnDesktop     = true;
    ShowStatusBar                   = true;
  };
}
