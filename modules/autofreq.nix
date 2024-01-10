{ ulib, ... }: with ulib;

desktopSystemConfiguration {
  services.auto-cpufreq = enabled {};
}
