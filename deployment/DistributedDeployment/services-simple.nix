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
  inherit system;
};
in
rec {
  HelloService = {
    name = "HelloService";
    pkg = pkgs.HelloService;
    dependsOn = {};
    type = "tomcat-webapplication";
  };
  
  HelloWorldService = {
    name = "HelloWorldService";
    pkg = pkgs.HelloWorldService;
    dependsOn = {
      inherit HelloService;
    };
    type = "tomcat-webapplication";
  };
  
  HelloWorld = {
    name = "HelloWorld";
    pkg = pkgs.HelloWorld;
    dependsOn = {
      inherit HelloWorldService;
    };
    type = "tomcat-webapplication";
  };  
}
