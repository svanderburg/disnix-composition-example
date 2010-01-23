/*
 * This Nix expression captures all the machines in the network and its properties
 */
{
  test1 = {
    hostname = "10.0.2.2";
    tomcatPort = 8082;
    mysqlPort = 3307;
    mysqlUsername = "root";
    mysqlPassword = "admin";
    targetEPR = http://10.0.2.2:8082/axis2/services/DisnixService;
    sshTarget = "localhost:2222";
    system = "i686-linux";
  };   
}
