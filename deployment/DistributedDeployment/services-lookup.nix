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

    LookupService = {
      name = "LookupService";
      pkg = customPkgs.LookupService;
      dependsOn = {};
      type = "tomcat-webapplication";
    };

    HelloWorldService2 = {
      name = "HelloWorldService2";
      pkg = customPkgs.HelloWorldService2;
      dependsOn = {
        inherit LookupService;
        inherit HelloService;
      };
      type = "tomcat-webapplication";
    };

    HelloWorld2 = {
      name = "HelloWorld2";
      pkg = customPkgs.HelloWorld2;
      dependsOn = {
        HelloWorldService = HelloWorldService2;
        inherit LookupService;
      };
      type = "tomcat-webapplication";
    };
  };
in
services
