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
  
  LookupService = import ../pkgs/LookupService {
    inherit stdenv apacheAnt axis2;
  };

  HelloWorldService2 = import ../pkgs/HelloWorldService2 {
    inherit stdenv apacheAnt axis2;
  };
    
  HelloDBService = import ../pkgs/HelloDBService {
    inherit stdenv apacheAnt axis2;
  };
  
  inherit (pkgs) mysql;
}
