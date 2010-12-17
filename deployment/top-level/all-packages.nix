/*
 * This Nix expression composes all the packages of the Hello World example.
 * Essentially this model captures all the intra-dependencies of a distributed system.
 */

{ distribution ? null # Take distribution model as optional input argument, which is needed by the lookup services
, services ? null # Take services model as optional input argument, which is needed by the lookup services
, system ? builtins.currentSystem
}:

# Imports the top-level expression from Nixpkgs
let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { inherit system; };
in
with pkgs;

rec {
  HelloService = import ../pkgs/HelloService {
    inherit stdenv apacheAnt axis2;
  };
  
  HelloWorldService = import ../pkgs/HelloWorldService {
    inherit stdenv apacheAnt axis2;
  };

  HelloWorld = import ../pkgs/HelloWorld {
    inherit stdenv apacheAnt axis2;
  };
  
  LookupConfig = if distribution == null || services == null then null else import ../pkgs/LookupConfig {
    inherit stdenv libxslt distribution services;
  };
  
  LookupService = import ../pkgs/LookupService {
    inherit stdenv apacheAnt axis2 LookupConfig;
  };

  HelloWorldService2 = import ../pkgs/HelloWorldService2 {
    inherit stdenv apacheAnt axis2;
  };

  HelloWorld2 = import ../pkgs/HelloWorld2 {
    inherit stdenv apacheAnt axis2;
  };
  
  HelloMySQLDB = import ../pkgs/HelloMySQLDB {
    inherit stdenv;
  };    
  
  HelloDBService = import ../pkgs/HelloDBService {
    inherit stdenv apacheAnt axis2;
  };
  
  HelloDBServiceWrapper = import ../pkgs/HelloDBService/wrapper.nix {
    inherit stdenv HelloDBService;
  };
  
  LookupService2 = import ../pkgs/LookupService2 {
    inherit stdenv apacheAnt axis2 LookupConfig;
  };
}
