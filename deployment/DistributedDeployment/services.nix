{distribution}:

let pkgs = import ../top-level/all-packages.nix;
in
rec {
  HelloService = {
    name = "HelloService";
    pkg = pkgs.HelloService;
    dependsOn = {};
    type = "webservice";
  };
  
  HelloWorldService = {
    name = "HelloWorldService";
    pkg = pkgs.HelloWorldService;
    dependsOn = {
      inherit HelloService;
    };
    type = "webservice";
  };
  
  LookupService = {
    name = "LookupService";
    pkg = pkgs.LookupService;
    dependsOn = {};
    type = "webservice";
  };
  
  HelloWorldService2 = {
    name = "HelloWorldService";
    pkg = pkgs.HelloWorldService2;
    dependsOn = {
      inherit LookupService;
      inherit HelloService;
    };
    type = "webservice";
  };
    
  HelloDBService = {
    name = "HelloService";
    pkg = pkgs.HelloDBService;
    dependsOn = {
      inherit MySQLService;
    };
    type = "webservice";
  };

  MySQLService = {
    name = "MySQLService";
    pkg = pkgs.mysql;
    dependsOn = {};
    type = "mysql";
  };
}
