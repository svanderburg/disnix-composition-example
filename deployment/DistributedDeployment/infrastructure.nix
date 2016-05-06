/*
 * This Nix expression captures all the machines in the network and its properties
 */
{
  test1 = {
    properties = {
      hostname = "10.0.2.2";
      targetEPR = http://10.0.2.2:8081/DisnixService/services/DisnixService;
      sshTarget = "localhost:2222";
    };
    
    containers = {
      tomcat-webapplication = {
        tomcatPort = 8081;
      };
    };
  };
  
  test2 = {
    properties = {
      hostname = "10.0.2.2";
      targetEPR = http://10.0.2.2:8082/DisnixService/services/DisnixService;
      sshTarget = "localhost:2223";
    };
    
    containers = {
      tomcat-webapplication = {
        tomcatPort = 8082;
      };
      
      mysql-database = {
        mysqlPort = 3307;
        mysqlUsername = "root";
        mysqlPassword = builtins.readFile ../configurations/mysqlpw;
      };
    };
  };
}
