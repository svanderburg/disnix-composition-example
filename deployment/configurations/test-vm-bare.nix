{pkgs, ...}:

{
  services = {
    openssh = {
      enable = true;
    };

    disnix = {
      enable = true;
    };
  };

  networking.firewall.enable = false;

  virtualisation.memorySize = 8192;

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.lynx
    ];
  };
}
