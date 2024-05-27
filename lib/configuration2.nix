lib: config: let
  userHomeConfiguration = users: cfg: {
    home-manager.users = lib.genAttrs users (lib.const cfg);
  };

  allNormalUsers = [ "root" ] ++ lib.pipe config.users.users [
    (lib.filterAttrs (lib.const (lib.getAttr "isNormalUser")))
    lib.attrNames
  ];

  desktopUsers = lib.pipe config.users.users [
    (lib.filterAttrs (lib.const (lib.getAttr "isDesktopUser")))
    lib.attrNames
  ];
in rec {
  inherit allNormalUsers desktopUsers;

  isDesktop = desktopUsers != [];
  isServer  = desktopUsers == [];

  desktopSystemConfiguration   = cfg: lib.optionalAttrs isDesktop cfg;
  desktopSystemPackages        = pkgs: desktopSystemConfiguration (lib.systemPackages pkgs);
  desktopSystemFonts           = pkgs: desktopSystemConfiguration (lib.systemFonts pkgs);
  desktopUserHomeConfiguration = cfg: userHomeConfiguration desktopUsers cfg;
  desktopUserHomePackages      = pkgs: desktopUserHomeConfiguration { home.packages = pkgs; };
  desktopHomeConfiguration     = cfg: desktopSystemConfiguration (lib.homeConfiguration cfg);
  desktopHomePackages          = pkgs: desktopHomeConfiguration { home.packages = pkgs; };

  serverSystemConfiguration = cfg: lib.optionalAttrs isServer cfg;
  serverSystemPackages      = pkgs: serverSystemConfiguration (lib.systemPackages pkgs);
  serverHomeConfiguration   = cfg: serverSystemConfiguration (lib.homeConfiguration cfg);
}
