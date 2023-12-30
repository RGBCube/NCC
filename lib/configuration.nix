normalUsers: graphicalUsers:

rec {
  inherit normalUsers graphicalUsers;

  systemConfiguration = configuration: configuration;

  systemPackages = packages: systemConfiguration {
    environment.systemPackages = packages;
  };

  systemFonts = packages: systemConfiguration {
    fonts.packages = packages;
  };

  userHomeConfiguration = users: configuration: {
    home-manager.users = builtins.foldl' (final: user: final // {
      ${user} = configuration;
    }) {} (if builtins.isList users then users else [ users ]);
  };

  graphicalConfiguration = userHomeConfiguration graphicalUsers;
  graphicalPackages      = packages: graphicalConfiguration {
    home.packages = packages;
  };

  homeConfiguration = userHomeConfiguration normalUsers;
  homePackages      = packages: homeConfiguration {
    home.packages = packages;
  };
}
