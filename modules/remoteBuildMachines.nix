{ ... }: {
  nix = {
    buildMachines = [{
      hostName = "lily.netbird.cloud";
      system = "x86_64-linux";
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
      protocol = "ssh-ng";
      sshKey = "/data/nixremote/id_ed25519";
      sshUser = "nixremote";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5hUmVOTStlU0l6Ylp2cWFoYU"
        + "FsYW5mMHo4OXJKUUlZV3gvcmxhUzRmMVkgcm9vdEBsaWx5Cg==";
    }];
    distributedBuilds = true;
  };
}
