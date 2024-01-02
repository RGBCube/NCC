{ ulib, ... }: with ulib; merge

(desktopSystemConfiguration {
  networking.networkmanager = enabled {};

  users.extraGroups.networkmanager.members = ulib.users.all;
})

(desktopHomeConfiguration {
  programs.nushell.shellAliases.wifi = "nmcli dev wifi show-password";
})
