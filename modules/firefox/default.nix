{ ulib, ... }: with ulib;

desktopHomeConfiguration {
  programs.firefox = enabled {};

  programs.librewolf = enabled {};
}
