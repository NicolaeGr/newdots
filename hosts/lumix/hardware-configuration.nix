{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1b4b2f26-ac69-4b6b-90fe-dd9d70a2e8bb";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1b4b2f26-ac69-4b6b-90fe-dd9d70a2e8bb";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1b4b2f26-ac69-4b6b-90fe-dd9d70a2e8bb";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/storage" = {
    device = "/dev/disk/by-uuid/065df52d-5eb8-4d0d-ab3d-e69133825609";
    fsType = "ext4";
    options = [
      "noatime"
      "data=ordered"
    ];
  };

  systemd.tmpfiles.rules = [ "D /storage 0777 root users - -" ];

  # # Makes /storage sticky. New files stay in 'users' group
  systemd.services.setup-storage-perms = {
    script = ''
      chmod g+s /storage

      chown root:users /storage
      chmod 0777 /storage
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStartPre = "-/bin/chmod 0777 /storage";
    };
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
