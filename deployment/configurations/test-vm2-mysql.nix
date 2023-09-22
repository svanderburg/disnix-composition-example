{pkgs, ...}:

{
  services = {
    openssh = {
      enable = true;
    };

    disnix = {
      enable = true;
      useWebServiceInterface = true;
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    tomcat = {
      enable = true;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-j.jar" ];
      catalinaOpts = "-Xms64m -Xmx256m";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3306 8080 ];

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
