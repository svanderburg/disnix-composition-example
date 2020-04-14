/*
 * This Nix expression captures all the components of a distributed system that
 * can be installed on machines in a network.
 *
 * This model also captures the inter-dependencies of a service and its type
 * which is used to decide how to activate and deactive services. 
 */

{distribution, invDistribution, system, pkgs}:

# Import the packages model of the Hello World example, which captures the intra-dependencies
let customPkgs = import ../top-level/all-packages.nix { 
  inherit system pkgs;
};
in
rec {
  HelloService = {
    name = "HelloService";
    pkg = customPkgs.HelloService;
    dependsOn = {};
    type = "tomcat-webapplication";
  };

  HelloWorldService = {
    name = "HelloWorldService";
    pkg = customPkgs.HelloWorldService;
    dependsOn = {
      inherit HelloService;
    };
    type = "tomcat-webapplication";
  };

  HelloWorld = {
    name = "HelloWorld";
    pkg = customPkgs.HelloWorld;
    dependsOn = {
      inherit HelloWorldService;
    };
    type = "tomcat-webapplication";
  };
}
