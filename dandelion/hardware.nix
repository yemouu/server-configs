{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    loader = {
      grub = {
          enable = true;
          configurationLimit = 50;
          device = "/dev/sda";
          copyKernels = true;
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
      device = "/dev/disk/by-uuid/1b032448-bc11-4d13-9f5b-c6e980288325";
      fsType = "btrfs";
      options = [ "subvol=@nixos/nix" "compress=zstd" ];
    };
    "/config" = {
      device = "/dev/disk/by-uuid/1b032448-bc11-4d13-9f5b-c6e980288325";
      fsType = "btrfs";
      options = [ "subvol=@nixos/config" "compress=zstd" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/1b032448-bc11-4d13-9f5b-c6e980288325";
      fsType = "btrfs";
      options = [ "subvol=@nixos/data" "compress=zstd" ];
      neededForBoot = true;
    };
    "/home/mou" = {
      device = "/dev/disk/by-uuid/1b032448-bc11-4d13-9f5b-c6e980288325";
      fsType = "btrfs";
      options = [ "subvol=@home/mou" "compress=zstd" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5cde8da8-fe2c-4177-90b3-000c32874610";
      fsType = "ext4";
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
          address = [ "2a01:4ff:f0:41c7::1/64" ];
          routes = [{ routeConfig.Gateway = "fe80::1"; }];
      };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
