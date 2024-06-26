{ themes, config, lib, pkgs, ... }: with lib; merge

(systemConfiguration {
  system.stateVersion  = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Istanbul";

  secrets.saidPassword.file  = ./password.said.age;

  users.users = {
    root.hashedPasswordFile = config.secrets.saidPassword.path;

    said = sudoUser (desktopUser {
      description        = "Said";
      hashedPasswordFile = config.secrets.saidPassword.path;
    });
  };

  theme = themes.custom (themes.raw.gruvbox-dark-hard // {
    cornerRadius = 0;
    borderWidth  = 1;

    margin  = 0;
    padding = 6;

    font.size.normal = 12;
    font.size.big    = 16;

    font.sans.name    = "Lexend";
    font.sans.package = pkgs.lexend;

    font.mono.name    = "JetBrainsMono Nerd Font";
    font.mono.package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });

    icons.name    = "Gruvbox-Plus-Dark";
    icons.package = pkgs.gruvbox-plus-icons;
  });
})

(homeConfiguration {
  home.stateVersion = "24.11";
})
