lib: {
  systemConfiguration = cfg: cfg;
  systemPackages      = pkgs: { environment.systemPackages = pkgs; };
  systemFonts         = pkgs: { fonts.packages = pkgs; };
  homeConfiguration   = cfg: { home-manager.sharedModules = [ cfg ]; };
}
