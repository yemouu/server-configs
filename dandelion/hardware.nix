{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
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
      device = "/dev/disk/by-uuid/f31dac70-545a-41bc-97da-39fabafb2b3b";
      fsType = "btrfs";
      options = [ "subvol=@nixos/nix" "compress=zstd" "discard=async" ];
    };
    "/config" = {
      device = "/dev/disk/by-uuid/f31dac70-545a-41bc-97da-39fabafb2b3b";
      fsType = "btrfs";
      options = [ "subvol=@nixos/config" "compress=zstd" "discard=async" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/f31dac70-545a-41bc-97da-39fabafb2b3b";
      fsType = "btrfs";
      options = [ "subvol=@nixos/data" "compress=zstd" "discard=async" ];
      neededForBoot = true;
    };
    "/home/mou" = {
      device = "/dev/disk/by-uuid/f31dac70-545a-41bc-97da-39fabafb2b3b";
      fsType = "btrfs";
      options = [ "subvol=@home/mou" "compress=zstd" "discard=async" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AA21-D01C";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" "defaults" ];
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
