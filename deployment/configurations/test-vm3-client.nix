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
  
  services = {
    openssh = {
      enable = true;
    };
    
    xserver = {
      enable = true;
      
      displayManager = {
        slim.enable = false;
	auto.enable = true;
      };
      
      windowManager = {
        default = "icewm";
        icewm = {
	  enable = true;
	};
      };
      
      desktopManager.default = "none";
    };
  };
  
  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
      pkgs.firefox
      pkgs.disnix
    ];
  };
}
