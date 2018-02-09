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
  HelloWorldCycle1 = {
    name = "HelloWorldCycle1";
    pkg = customPkgs.HelloWorldCycle;
    connectsTo = {
      HelloWorldCycle = HelloWorldCycle2; # Depends on the other cyclic service
    };
    type = "tomcat-webapplication";
  };

  HelloWorldCycle2 = {
    name = "HelloWorldCycle2";
    pkg = customPkgs.HelloWorldCycle;
    connectsTo = {
      HelloWorldCycle = HelloWorldCycle1; # Depends on the other cyclic service
    };
    type = "tomcat-webapplication";
  };
}
