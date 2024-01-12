{ ulib, ... }: with ulib;

systemConfiguration {
  users.mutableUsers = false;
}
