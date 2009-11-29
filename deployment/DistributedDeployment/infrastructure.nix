/*
 * This Nix expression captures all the machines in the network and its properties
 */
{
  test1 = {
    hostname = "test1.localhost";
    tomcatPort = 8080;
    mysqlPort = 3306;
    targetEPR = http://test1.localhost/axis2/services/DisnixService;
    system = "x86_64-linux";
  };
   
  test2 = {
    hostname = "test2.localhost";
    tomcatPort = 8080;
    mysqlPort = 3306;
    targetEPR = http://test2.localhost/axis2/services/DisnixService;
    system = "i686-linux";
  };
}
