rec {
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

  # FIXME: Don't hardcode these.
  graphicalConfiguration = userHomeConfiguration "nixos";
  graphicalPackages      = packages: graphicalConfiguration {
    home.packages = packages;
  };

  # FIXME: Don't hardcode these.
  homeConfiguration = userHomeConfiguration [ "nixos" "root" ];
  homePackages      = packages: homeConfiguration {
    home.packages = packages;
  };
}
