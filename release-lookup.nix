{ nixpkgs ? /etc/nixos/nixpkgs
, nixos ? /etc/nixos/nixos
, system ? builtins.currentSystem
}:

let
  pkgs = import nixpkgs { inherit system; };
  
  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs nixos system;
  };
  
  jobs = rec {
    tarball =
      { HelloWorldExample ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false}:
    
      disnixos.sourceTarball {
        name = "HelloWorldExample";
	version = builtins.readFile ./version;
	src = HelloWorldExample;
        inherit officialRelease;
      };
      
    build =
      { tarball ? jobs.tarball {} }:
      
      disnixos.buildManifest {
        name = "HelloWorldExample-lookup";
	version = builtins.readFile ./version;
	inherit tarball;
	servicesFile = "deployment/DistributedDeployment/services-lookup.nix";
	networkFile = "deployment/DistributedDeployment/network.nix";
	distributionFile = "deployment/DistributedDeployment/distribution-lookup.nix";
      };
            
    tests = 
      disnixos.disnixTest {
        name = "HelloWorldExample-lookup";
        tarball = tarball {};
        manifest = build {};
	networkFile = "deployment/DistributedDeployment/network.nix";
	testScript =
	  ''
	    $test1->waitForFile("/var/tomcat/webapps/HelloWorld2");
	    $test1->mustSucceed("sleep 30; curl --fail http://test1:8080/HelloWorld2/index.jsp >&2");
	    $test3->mustSucceed("firefox http://test1:8080/HelloWorld2 &");
	    $test3->mustSucceed("sleep 15");
	      
	    $test3->screenshot("screen");
	  '';
      };
  };
in
jobs
