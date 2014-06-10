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
    
    doc =
      pkgs.releaseTools.nixBuild {
        name = "disnix-composition-example-doc";
        version = builtins.readFile ./version;
        src = tarball;
        buildInputs = [ pkgs.libxml2 pkgs.libxslt pkgs.dblatex pkgs.tetex ];
        
        buildPhase = ''
          cd doc
          make docbookrng=${pkgs.docbook5}/xml/rng/docbook docbookxsl=${pkgs.docbook5_xsl}/xml/xsl/docbook
        '';
        
        checkPhase = "true";
        
        installPhase = ''
          make DESTDIR=$out install
         
          echo "doc manual $out/share/doc/HelloWorldExample/manual" >> $out/nix-support/hydra-build-products
        '';
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
          tarball = tarball {};
          manifest = (builds { system = "x86_64-linux"; }).simple;
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
          tarball = tarball {};
          manifest = (builds { system = "x86_64-linux"; }).composition;
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
          tarball = tarball {};
          manifest = (builds { system = "x86_64-linux"; }).lookup;
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
          tarball = tarball {};
          manifest = (builds { system = "x86_64-linux"; }).loadbalancing;
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