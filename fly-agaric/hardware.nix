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
      device = "/dev/disk/by-uuid/e224cad1-1ea2-435b-b914-b16eb400cd36";
      fsType = "btrfs";
      options = [ "subvol=@nixos/nix" "compress=zstd" ];
    };
    "/config" = {
      device = "/dev/disk/by-uuid/e224cad1-1ea2-435b-b914-b16eb400cd36";
      fsType = "btrfs";
      options = [ "subvol=@nixos/config" "compress=zstd" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/e224cad1-1ea2-435b-b914-b16eb400cd36";
      fsType = "btrfs";
      options = [ "subvol=@nixos/data" "compress=zstd" ];
      neededForBoot = true;
    };
    "/home/mou" = {
      device = "/dev/disk/by-uuid/e224cad1-1ea2-435b-b914-b16eb400cd36";
      fsType = "btrfs";
      options = [ "subvol=@home/mou" "compress=zstd" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/00e4dfc3-8bf9-4075-92fa-3da33ef09704";
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
          address = [ "2a01:4ff:f0:348a::1/64" ];
          routes = [{ Gateway = "fe80::1"; }];
      };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
