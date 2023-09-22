{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, spoolDir ? "${stateDir}/spool"
, libDir ? "${stateDir}/lib"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "systemd"
, nix-processmgmt ? ../../../nix-processmgmt
, nix-processmgmt-services ? ../../../nix-processmgmt-services
}:

let
  processType = import "${nix-processmgmt}/nixproc/derive-dysnomia-process-type.nix" {
    inherit processManager;
  };

  constructors = import "${nix-processmgmt-services}/service-containers-agnostic/constructors.nix" {
    inherit nix-processmgmt pkgs stateDir runtimeDir logDir cacheDir spoolDir libDir tmpDir forceDisableUserChange processManager;
  };

  customPkgs = import ../top-level/all-packages.nix {
    inherit system pkgs stateDir;
  };
in
rec {
### Container providers

  tomcat = constructors.simpleAppservingTomcat {
    httpPort = 8080;
    commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-j.jar" ];
    type = processType;
  };

  axis2 = customPkgs.axis2 {};

### Web services

  HelloService = {
    name = "HelloService";
    pkg = customPkgs.HelloService;
    dependsOn = {};
    type = "axis2-webservice";
  };

  HelloWorldService = {
    name = "HelloWorldService";
    pkg = customPkgs.HelloWorldService;
    dependsOn = {
      inherit HelloService;
    };
    type = "axis2-webservice";
  };

### Web applications

  HelloWorld = {
    name = "HelloWorld";
    pkg = customPkgs.HelloWorld;
    dependsOn = {
      inherit HelloWorldService;
    };
    type = "tomcat-webapplication";
  };
}
