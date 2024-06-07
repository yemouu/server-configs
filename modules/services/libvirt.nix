{ pkgs, ... }: {
  users.users.mou.extraGroups = [ "libvirtd" ];

  environment.persistence."/data/persistent".directories = [
    "/var/lib/libvirt"
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
}
