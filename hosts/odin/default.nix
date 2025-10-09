{
  inputs,
  config,
  configLib,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.lenovo-ideapad-15arh05
    ./hardware-configuration.nix
  ]
  ++ (map configLib.relativeToRoot [
    "hosts/_common/core"
    "hosts/_common/extra"
    "hosts/_common/users"
  ]);

  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  boot.kernelModules = [ "acpi_call" ];
  boot.kernelParams = [
    "acpi_backlight=vendor"
    "nvidia_drm.fbdev=1"
  ];

  extra.gui.enable = true;

  semi-active-av.enable = true;
}
