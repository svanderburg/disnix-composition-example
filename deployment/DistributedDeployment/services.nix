/*
 * This Nix expression captures all the components of a distributed system that
 * can be installed on machines in a network.
 *
 * This model also captures the inter-dependencies of a service and its type
 * which is used to decide how to activate and deactive services. 
 */
 
{distribution}:

# Import the packages model of the Hello World example, which captures the intra-dependencies
let pkgs = import ../top-level/all-packages.nix { inherit distribution; };
in
rec {
  HelloService = {
    name = "HelloService";
    pkg = pkgs.HelloService;
    dependsOn = {};
    type = "webservice";
  };
  
  HelloWorldService = {
    name = "HelloWorldService";
    pkg = pkgs.HelloWorldService;
    dependsOn = {
      inherit HelloService;
    };
    type = "webservice";
  };
  
  LookupService = {
    name = "LookupService";
    pkg = pkgs.LookupService;
    dependsOn = {};
    type = "webservice";
  };
  
  HelloWorldService2 = {
    name = "HelloWorldService";
    pkg = pkgs.HelloWorldService2;
    dependsOn = {
      inherit LookupService;
      inherit HelloService;
    };
    type = "webservice";
  };
    
  HelloMySQLDB = {
    name = "HelloMySQLDB";
    pkg = pkgs.HelloMySQLDB;
    dependsOn = {};
    type = "mysql-database";
  };

  HelloDBService = {
    name = "HelloService";
    pkg = pkgs.HelloDBService;
    dependsOn = {
      inherit HelloMySQLDB;
    };
    type = "webservice";
  };
}
