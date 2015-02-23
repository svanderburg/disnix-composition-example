/*
 * This Nix expression composes all the packages of the Hello World example.
 * Essentially this model captures all the intra-dependencies of a distributed system.
 */

{ distribution ? null # Take distribution model as optional input argument, which is needed by the lookup services
, services ? null # Take services model as optional input argument, which is needed by the lookup services
, system ? builtins.currentSystem
, pkgs
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    HelloService = callPackage ../pkgs/HelloService { };
  
    HelloWorldService = callPackage ../pkgs/HelloWorldService { };

    HelloWorld = callPackage ../pkgs/HelloWorld { };
  
    LookupConfig = if distribution == null || services == null then null else callPackage ../pkgs/LookupConfig {
      inherit services distribution;
    };
  
    LookupService = callPackage ../pkgs/LookupService { };

    HelloWorldService2 = callPackage ../pkgs/HelloWorldService2 { };

    HelloWorld2 = callPackage ../pkgs/HelloWorld2 { };
  
    HelloMySQLDB = callPackage ../pkgs/HelloMySQLDB { };
  
    HelloDBService = callPackage ../pkgs/HelloDBService { };
  
    HelloDBServiceWrapper = callPackage ../pkgs/HelloDBService/wrapper.nix { };
  
    LookupService2 = callPackage ../pkgs/LookupService2 { };
  };
in
self
