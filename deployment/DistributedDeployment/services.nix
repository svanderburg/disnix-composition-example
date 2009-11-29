/*
 * This Nix expression captures all the components of a distributed system that
 * can be installed on machines in a network.
 *
 * This model also captures the inter-dependencies of a service and its type
 * which is used to decide how to activate and deactive services. 
 */
 
{distribution, system}:

# Import the packages model of the Hello World example, which captures the intra-dependencies
let pkgs = import ../top-level/all-packages.nix { 
   inherit distribution; # Pass distribution model to the packages model, so that the lookup services can use them
   inherit system;
};
in
rec {
  HelloService = {
    name = "HelloService";
    pkg = pkgs.HelloService;
    dependsOn = {};
    type = "axis2-webservice";
  };
  
  HelloWorldService = {
    name = "HelloWorldService";
    pkg = pkgs.HelloWorldService;
    dependsOn = {
      inherit HelloService;
    };
    type = "axis2-webservice";
  };
  
  HelloWorld = {
    name = "HelloWorld";
    pkg = pkgs.HelloWorld;
    dependsOn = {
      inherit HelloWorldService;
    };
    type = "tomcat-webapplication";
  };
  
  LookupService = {
    name = "LookupService";
    pkg = pkgs.LookupService;
    dependsOn = {};
    type = "axis2-webservice";
  };
  
  HelloWorldService2 = {
    name = "HelloWorldService2";
    pkg = pkgs.HelloWorldService2;
    dependsOn = {
      inherit LookupService;
      inherit HelloService;
    };
    type = "axis2-webservice";
  };
  
  HelloWorld2 = {
    name = "HelloWorld2";
    pkg = pkgs.HelloWorld2;
    dependsOn = {
      HelloWorldService = HelloWorldService2;
      inherit LookupService;
    };
    type = "tomcat-webapplication";
  };
    
  HelloMySQLDB = {
    name = "HelloMySQLDB";
    pkg = pkgs.HelloMySQLDB;
    dependsOn = {};
    type = "mysql-database";
  };

  HelloDBService = {
    name = "HelloDBService";
    pkg = pkgs.HelloDBServiceWrapper;
    dependsOn = {
      inherit HelloMySQLDB;
    };
    type = "axis2-webservice";
  };
  
  LookupService2 = {
    name = "LookupService2";
    pkg = pkgs.LookupService2;
    dependsOn = {};
    type = "axis2-webservice";
  };
}
