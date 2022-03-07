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

    tomcat = {
      enable = true;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      catalinaOpts = "-Xms64m -Xmx256m";
      package = pkgs.tomcat9;
    };
  };

  users.users.tomcat.group = "tomcat";

  networking.firewall.allowedTCPPorts = [ 8080 ];

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
