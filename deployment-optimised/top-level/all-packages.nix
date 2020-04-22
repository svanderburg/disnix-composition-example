{system, pkgs, stateDir}:

let
  customPkgs = import ../../deployment/top-level/all-packages.nix {
    inherit system pkgs;
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // customPkgs // self);

  self = {
### Web services

    HelloService = callPackage ../pkgs/HelloService { };

    HelloWorldService = callPackage ../pkgs/HelloWorldService { };

### Web applications

    HelloWorld = callPackage ../pkgs/HelloWorld { };
  };
in
customPkgs // self // {
  axis2 = import ../pkgs/axis2 {
    inherit stateDir;
    inherit (pkgs) stdenv axis2;
    dysnomia = pkgs.dysnomia.override (origArgs: {
      enableAxis2WebService = true;
    });
  };
}
