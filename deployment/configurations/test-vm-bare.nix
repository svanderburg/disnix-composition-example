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

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.lynx
    ];
  };
  
  dysnomia = {
    extraModulePaths = [ "/nix/var/nix/profiles/disnix/containers/etc/dysnomia/modules" ];
    extraContainerPaths = [ "/nix/var/nix/profiles/disnix/containers/etc/dysnomia/containers" ];
  };
}
