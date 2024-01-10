users: let
  userHomeConfiguration = users: configuration: {
    home-manager.users = builtins.foldl' (final: user: final // {
      ${user} = configuration;
    }) {} (if builtins.isList users then users else [ users ]);
  };
in rec {
  inherit users;

  isServer  = users.graphical == [];
  isDesktop = !isServer;

  # For every machine.
  systemConfiguration = configuration: configuration;
  systemPackages      = packages: systemConfiguration { environment.systemPackages = packages; };
  systemFonts         = packages: systemConfiguration { fonts.packages = packages; };

  # For every user, on every machine.
  homeConfiguration = configuration: { home-manager.sharedModules = [ configuration ]; };
  homePackages      = packages: homeConfiguration { home.packages = packages; };

  # For every desktop.
  desktopSystemConfiguration = configuration: if isServer then {} else configuration;
  desktopSystemPackages      = packages:      if isServer then {} else systemPackages packages;
  desktopSystemFonts         = packages:      if isServer then {} else systemFonts packages;
  # For every graphical user on every desktop.
  desktopHomeConfiguration   = configuration: if isServer then {} else userHomeConfiguration users.graphical configuration;
  desktopHomePackages        = packages:      if isServer then {} else desktopHomeConfiguration { home.packages = packages; };

  # For every server.
  serverSystemConfiguration  = configuration: if isServer then configuration else {};
  serverSystemPackages       = packages:      if isServer then systemPackages packages else {};
  serverSystemFonts          = packages:      if isServer then systemFonts packages else {};
  # For every user on every server.
  serverHomeConfiguration    = configuration: if isServer then homeConfiguration configuration else {};
  serverHomePackages         = packages:      if isServer then homePackages packages else {};
}
