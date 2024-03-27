{ lib, ... }: with lib;

systemConfiguration {
  boot.tmp.cleanOnBoot = true;
}
