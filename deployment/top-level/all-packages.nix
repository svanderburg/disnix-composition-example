{distribution ? null # Take distribution model as optional input argument, needed by the lookup services
}:

/*
 * This Nix expression composes all the packages of the Hello World example.
 * Essentially this model captures all the intra-dependencies of a distributed system.
 */

# Imports the top-level expression from Nixpkgs
let pkgs = import (builtins.getEnv "NIXPKGS_ALL") {};
in
with pkgs;

rec {
  HelloService = import ../pkgs/HelloService {
    inherit stdenv apacheAnt;
  };
  
  HelloWorldService = import ../pkgs/HelloWorldService {
    inherit stdenv apacheAnt axis2;
  };
  
  LookupConfig = if distribution == null then null else import ../pkgs/LookupConfig {
    inherit stdenv libxslt distribution;
  };
  
  LookupService = import ../pkgs/LookupService {
    inherit stdenv apacheAnt axis2;
  };

  HelloWorldService2 = import ../pkgs/HelloWorldService2 {
    inherit stdenv apacheAnt axis2;
  };
    
  HelloMySQLDB = import ../pkgs/HelloMySQLDB {
    inherit stdenv;
  };
  
  HelloDBService = import ../pkgs/HelloDBService {
    inherit stdenv apacheAnt axis2;
  };  
}
