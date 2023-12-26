{ ulib, ... }: with ulib; merge

(systemConfiguration {
  networking.networkmanager = enabled {};

  users.extraGroups.networkmanager.members = [ "nixos" ];
})

(homeConfiguration {
  programs.nushell.shellAliases.wifi = "nmcli dev wifi show-password";
})
