{ ulib, ... }: with ulib;

systemConfiguration {
  boot.tmp.cleanOnBoot = true;
}
