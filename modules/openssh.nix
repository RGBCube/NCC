{ ulib, ... }: with ulib;

serverSystemConfiguration {
  programs.mosh = enabled {
    openFirewall = true;
  };

  services.openssh = enabled {
    banner   = ''
       _________________________________________
      / You will pay for your sins. If you have \
      | already paid, please disregard this     |
      \ message.                                /
       -----------------------------------------
            \                    / \  //\
             \    |\___/|      /   \//  \\
                  /0  0  \__  /    //  | \ \
                 /     /  \/_/    //   |  \  \
                 @_^_@'/   \/_   //    |   \   \
                 //_^_/     \/_ //     |    \    \
              ( //) |        \///      |     \     \
            ( / /) _|_ /   )  //       |      \     _\
          ( // /) '/,_ _ _/  ( ; -.    |    _ _\.-~        .-~~~^-.
        (( / / )) ,-{        _      `-.|.-~-.           .~         `.
       (( // / ))  '/\      /                 ~-. _ .-~      .-~^-.  \
       (( /// ))      `.   {            }                   /      \  \
        (( / ))     .----~-.\        \-'                 .~         \  `. \^-.
                   ///.----..>        \             _ -~             `.  ^-`  ^-_
                     ///-._ _ _ _ _ _ _}^ - - - - ~                     ~-- ,.-~
                                                                        /.-~
    '';
    ports    = [ 2222 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
