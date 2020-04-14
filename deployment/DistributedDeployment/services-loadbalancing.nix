/*
 * This Nix expression captures all the components of a distributed system that
 * can be installed on machines in a network.
 *
 * This model also captures the inter-dependencies of a service and its type
 * which is used to decide how to activate and deactive services. 
 */

{distribution, invDistribution, system, pkgs}:

# Import the packages model of the Hello World example, which captures the intra-dependencies
let
  customPkgs = import ../top-level/all-packages.nix { 
    inherit distribution; # Pass distribution model to the packages model, so that the lookup services can use them
    inherit services; # Pass services model to the packages model, so that the lookup services can use them
    inherit system pkgs;
  };

  services = rec {
    HelloService = {
      name = "HelloService";
      pkg = customPkgs.HelloService;
      dependsOn = {};
      type = "tomcat-webapplication";
    };

    HelloWorldService2 = {
      name = "HelloWorldService2";
      pkg = customPkgs.HelloWorldService2;
      dependsOn = {
        LookupService = LookupService2; # Use the advanced load balancing lookup service
        inherit HelloService;
      };
      type = "tomcat-webapplication";
    };

    LookupService2 = {
      name = "LookupService2";
      pkg = customPkgs.LookupService2;
      dependsOn = {};
      type = "tomcat-webapplication";
    };

    HelloWorld2 = {
      name = "HelloWorld2";
      pkg = customPkgs.HelloWorld2;
      dependsOn = {
        HelloWorldService = HelloWorldService2;
        LookupService = LookupService2; # Use the advanced load balancing lookup service
      };
      type = "tomcat-webapplication";
    };
  };
in
services
