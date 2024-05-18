{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        configurationLimit = 50;
        consoleMode = "auto";
        enable = true;
      };
      timeout = 0;
    };
    tmp = {
      useTmpfs = true;
      # tmpfsSize = "100%";
    };
  };

  zramSwap.enable = true;

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/4278aaa1-dc94-42a1-a7d0-57c9dca9defe";
      fsType = "btrfs";
      options = [ "subvol=@nixos/nix" "compress=zstd" ];
    };
    "/config" = {
      device = "/dev/disk/by-uuid/4278aaa1-dc94-42a1-a7d0-57c9dca9defe";
      fsType = "btrfs";
      options = [ "subvol=@nixos/config" "compress=zstd" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/4278aaa1-dc94-42a1-a7d0-57c9dca9defe";
      fsType = "btrfs";
      options = [ "subvol=@nixos/data" "compress=zstd" ];
      neededForBoot = true;
    };
    "/home/mou" = {
      device = "/dev/disk/by-uuid/4278aaa1-dc94-42a1-a7d0-57c9dca9defe";
      fsType = "btrfs";
      options = [ "subvol=@home/mou" "compress=zstd" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/347E-11CA";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" "defaults" ];
    };
  };

  hardware.enableRedistributableFirmware = true;

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault false;
  systemd.network = {
      enable = true;
      networks."10-wan" = {
          matchConfig.Name = "enp1s0";
          networkConfig.DHCP = "ipv4";
          address = [ "2a01:4f8:c0c:580d::1/64" ];
          routes = [{ routeConfig.Gateway = "fe80::1"; }];
      };
  };
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
