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

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelModules = [ "acpi_call" ];

    kernelParams = [
      "acpi_backlight=vendor"
      "nvidia_drm.fbdev=1"
      # Hibernation
      "resume=/dev/disk/by-uuid/aad364ae-89b5-4400-aa98-9a58dadb513f"
      "resume_offset=269568"
    ];

    resumeDevice = "/dev/disk/by-uuid/aad364ae-89b5-4400-aa98-9a58dadb513f";
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];

  fileSystems = {
    "/".options = [ "subvol=@,compress=zstd,noatime" ];
    "/home".options = [ "subvol=@home,compress=zstd,noatime" ];
    "/nix".options = [ "subvol=@nix,compress=zstd,noatime" ];
    "/var/log".options = [ "subvol=@log,compress=zstd,noatime" ];
    "/.snapshots".options = [ "subvol=@snapshots,compress=zstd,noatime" ];
    "/swap".options = [ "subvol=@swap,compress=none,noatime" ];
  };

  extra.gui.enable = true;
  extra.gui.hyprland.enable = true;

  semi-active-av.enable = true;

  #  system.stateVersion = "24.11";
}
