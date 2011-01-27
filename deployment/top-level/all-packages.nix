/*
 * This Nix expression composes all the packages of the Hello World example.
 * Essentially this model captures all the intra-dependencies of a distributed system.
 */

{ distribution ? null # Take distribution model as optional input argument, which is needed by the lookup services
, services ? null # Take services model as optional input argument, which is needed by the lookup services
, system ? builtins.currentSystem
, pkgs
}:

rec {
  HelloService = import ../pkgs/HelloService {
    inherit (pkgs) stdenv apacheAnt axis2;
  };
  
  HelloWorldService = import ../pkgs/HelloWorldService {
    inherit (pkgs) stdenv apacheAnt axis2;
  };

  HelloWorld = import ../pkgs/HelloWorld {
    inherit (pkgs) stdenv apacheAnt axis2;
  };
  
  LookupConfig = if distribution == null || services == null then null else import ../pkgs/LookupConfig {
    inherit (pkgs) stdenv libxslt;
    inherit distribution services;
  };
  
  LookupService = import ../pkgs/LookupService {
    inherit (pkgs) stdenv apacheAnt axis2;
    inherit LookupConfig;
  };

  HelloWorldService2 = import ../pkgs/HelloWorldService2 {
    inherit (pkgs) stdenv apacheAnt axis2;
  };

  HelloWorld2 = import ../pkgs/HelloWorld2 {
    inherit (pkgs) stdenv apacheAnt axis2;
  };
  
  HelloMySQLDB = import ../pkgs/HelloMySQLDB {
    inherit (pkgs) stdenv;
  };    
  
  HelloDBService = import ../pkgs/HelloDBService {
    inherit (pkgs) stdenv apacheAnt axis2;
  };
  
  HelloDBServiceWrapper = import ../pkgs/HelloDBService/wrapper.nix {
    inherit (pkgs) stdenv;
    inherit HelloDBService;
  };
  
  LookupService2 = import ../pkgs/LookupService2 {
    inherit (pkgs) stdenv apacheAnt axis2;
    inherit LookupConfig;
  };
}
