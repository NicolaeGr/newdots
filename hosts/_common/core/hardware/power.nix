{ lib, ... }:
{
  services.tlp.enable = lib.mkForce false;

  services.auto-cpufreq.enable = true;
}
