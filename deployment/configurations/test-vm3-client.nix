{pkgs, ...}:

{
  services = {
    disnix = {
      enable = true;
    };
    
    openssh = {
      enable = true;
    };
    
    xserver = {
      enable = true;
      
      displayManager = {
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
    ];
  };
}
