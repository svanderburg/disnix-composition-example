{ nixpkgs ? <nixpkgs>
, disnix_composition_example ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};
  
  jobs = rec {
    
    tarball =
      let
        pkgs = import nixpkgs {};
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      disnixos.sourceTarball {
        name = "disnix-composition-example-tarball";
        version = builtins.readFile ./version;
        src = disnix_composition_example;
        inherit officialRelease;
      };
    
    builds =
      {
        simple = pkgs.lib.genAttrs systems (system:
          let
            pkgs = import nixpkgs { inherit system; };
  
            disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
              inherit nixpkgs system;
            };
          in
          disnixos.buildManifest {
            name = "disnix-composition-example-simple";
            version = builtins.readFile ./version;
            inherit tarball;
            servicesFile = "deployment/DistributedDeployment/services-simple.nix";
            networkFile = "deployment/DistributedDeployment/network.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-simple.nix";
          });
        
        composition = pkgs.lib.genAttrs systems (system:
          let
            pkgs = import nixpkgs { inherit system; };
  
            disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
              inherit nixpkgs system;
            };
          in
          disnixos.buildManifest {
            name = "disnix-composition-example-composition";
            version = builtins.readFile ./version;
            inherit tarball;
            servicesFile = "deployment/DistributedDeployment/services-composition.nix";
            networkFile = "deployment/DistributedDeployment/network.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-composition.nix";
          });
        
        lookup = pkgs.lib.genAttrs systems (system:
          let
            pkgs = import nixpkgs { inherit system; };
  
            disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
              inherit nixpkgs system;
            };
          in
          disnixos.buildManifest {
            name = "disnix-composition-example-lookup";
            version = builtins.readFile ./version;
            inherit tarball;
            servicesFile = "deployment/DistributedDeployment/services-lookup.nix";
            networkFile = "deployment/DistributedDeployment/network.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-lookup.nix";
          });
        
        loadbalancing = pkgs.lib.genAttrs systems (system:
          let
            pkgs = import nixpkgs { inherit system; };
  
            disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
              inherit nixpkgs system;
            };
          in
          disnixos.buildManifest {
            name = "disnix-composition-example-loadbalancing";
            version = builtins.readFile ./version;
            inherit tarball;
            servicesFile = "deployment/DistributedDeployment/services-loadbalancing.nix";
            networkFile = "deployment/DistributedDeployment/network.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-loadbalancing.nix";
          });
      };
            
    tests =
      let
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      {
        simple = disnixos.disnixTest {
          name = "disnix-composition-example-simple-test";
          inherit tarball;
          manifest = builtins.getAttr (builtins.currentSystem) (builds.simple);
          networkFile = "deployment/DistributedDeployment/network.nix";
          testScript =
            ''
              $test1->waitForFile("/var/tomcat/webapps/HelloWorld");
              my $result = $test1->mustSucceed("sleep 30; curl --fail http://test1:8080/HelloWorld/index.jsp");
            
              # The entry page should contain Hello World
            
              if ($result =~ /Hello world/) {
                  print "Entry page contains: Hello world!\n";
              } else {
                  die "Entry page should contain Hello world!\n";
              }
            
              $test3->mustSucceed("firefox http://test1:8080/HelloWorld/index.jsp &");
              $test3->waitForWindow(qr/Nightly/);
              $test3->mustSucceed("sleep 30");
              $test3->screenshot("screen");
          '';
        };
        
        composition = disnixos.disnixTest {
          name = "disnix-composition-example-composition-test";
          inherit tarball;
          manifest = builtins.getAttr (builtins.currentSystem) (builds.composition);
          networkFile = "deployment/DistributedDeployment/network.nix";
          testScript =
            ''
              $test1->waitForFile("/var/tomcat/webapps/HelloWorld");
              my $result = $test1->mustSucceed("sleep 30; curl --fail http://test1:8080/HelloWorld/index.jsp");
              
              # The entry page should contain Hello World
              
              if ($result =~ /Hello world/) {
                  print "Entry page contains: Hello world!\n";
              } else {
                  die "Entry page should contain Hello world!\n";
              }
            
              $test3->mustSucceed("firefox http://test1:8080/HelloWorld &");
              $test3->waitForWindow(qr/Nightly/);
              $test3->mustSucceed("sleep 30");
              $test3->screenshot("screen");
            '';
        };
        
        lookup = disnixos.disnixTest {
          name = "disnix-composition-example-lookup-test";
          inherit tarball;
          manifest = builtins.getAttr (builtins.currentSystem) (builds.lookup);
          networkFile = "deployment/DistributedDeployment/network.nix";
          testScript =
            ''
              $test1->waitForFile("/var/tomcat/webapps/HelloWorld2");
              my $result = $test1->mustSucceed("sleep 30; curl --fail http://test1:8080/HelloWorld2/index.jsp");
            
              # The entry page should contain Hello World
            
              if ($result =~ /Hello world/) {
                  print "Entry page contains: Hello world!\n";
              } else {
                  die "Entry page should contain Hello world!\n";
              }
            
              $test3->mustSucceed("firefox http://test1:8080/HelloWorld2 &");
              $test3->waitForWindow(qr/Nightly/);
              $test3->mustSucceed("sleep 30");
              $test3->screenshot("screen");
            '';
        };
        
        loadbalancing = disnixos.disnixTest {
          name = "disnix-composition-example-loadbalancing-test";
          inherit tarball;
          manifest = builtins.getAttr (builtins.currentSystem) (builds.loadbalancing);
          networkFile = "deployment/DistributedDeployment/network.nix";
          testScript =
            ''
              $test1->waitForFile("/var/tomcat/webapps/HelloWorld2");
              my $result = $test1->mustSucceed("sleep 30; curl --fail http://test1:8080/HelloWorld2/index.jsp");
            
              # The entry page should contain Hello World
            
              if ($result =~ /Hello world/) {
                  print "Entry page contains: Hello world!\n";
              } else {
                  die "Entry page should contain Hello world!\n";
              }
            
              $test3->mustSucceed("firefox http://test1:8080/HelloWorld2 &");
              $test3->waitForWindow(qr/Nightly/);
              $test3->mustSucceed("sleep 30");
              $test3->screenshot("screen");
            '';
        };
      };
  };
in
jobs
