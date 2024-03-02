{ ulib, ... }: with ulib;

serverSystemConfiguration {
  programs.mosh = enabled {
    openFirewall = true;
  };

  services.openssh = enabled {
    banner   = ''
       _______________________________________
      / If God doesn't destroy San Francisco, \
      | He should apologize to Sodom and      |
      \ Gomorrah.                             /
       ---------------------------------------
              \   ^__^
               \  (oo)\_______
                  (__)\       )\/\
                      ||----w |
                      ||     ||
    '';
    ports    = [ 2222 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
