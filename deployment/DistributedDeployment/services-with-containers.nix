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

  applicationServices = import ./services-simple.nix {
    inherit pkgs system distribution invDistribution;
  };
in
rec {
  tomcat = constructors.simpleAppservingTomcat {
    httpPort = 8080;
    commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-j.jar" ];
    type = processType;
  };

  mysql = constructors.mysql {
    port = 3306;
    type = processType;
  };
} // applicationServices
