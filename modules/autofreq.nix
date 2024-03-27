{ lib, ... }: with lib;

desktopSystemConfiguration {
  services.auto-cpufreq = enabled;
}
