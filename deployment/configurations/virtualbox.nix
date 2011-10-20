{pkgs, ...}:

{
  boot = {
    loader = {
      grub = {
        device = "/dev/sda";
      };
    };
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda2";
    }
  ];

  swapDevices = [
    { device = "/dev/sda1"; }
  ];
}
