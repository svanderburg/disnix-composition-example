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

    disnix = {
      enable = true;
    };

    mysql = {
      enable = true;
      rootPassword = ./mysqlpw;
      initialScript = ./mysqlscript;
    };

    tomcat = {
      enable = true;
      
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      
      javaOpts = "-Djava.library.path=${pkgs.libmatthew_java}/lib/jni";
      catalinaOpts = "-Xms64m -Xmx256m";
      sharedLibs = [ "${pkgs.DisnixService}/share/java/DisnixConnection.jar"
                     "${pkgs.dbus_java}/share/java/dbus.jar" ];
      webapps = [ pkgs.DisnixService ];
    };
  };

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
