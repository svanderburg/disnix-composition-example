{ nixpkgs ? <nixpkgs>
, disnix_composition_example ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};

  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs;
  };

  version = builtins.readFile ./version;

  jobs = rec {
    tarball = disnixos.sourceTarball {
      name = "disnix-composition-example-tarball";
      src = disnix_composition_example;
      inherit officialRelease version;
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
            inherit tarball version;
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
            inherit tarball version;
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
            inherit tarball version;
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
            inherit tarball version;
            servicesFile = "deployment/DistributedDeployment/services-loadbalancing.nix";
            networkFile = "deployment/DistributedDeployment/network.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-loadbalancing.nix";
          });

        cyclic = pkgs.lib.genAttrs systems (system:
          let
            pkgs = import nixpkgs { inherit system; };

            disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
              inherit nixpkgs system;
            };
          in
          disnixos.buildManifest {
            name = "disnix-composition-example-cyclic";
            inherit tarball version;
            servicesFile = "deployment/DistributedDeployment/services-cyclic.nix";
            networkFile = "deployment/DistributedDeployment/network.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-cyclic.nix";
          });
      };

    tests = {
      simple = import ./tests/simple.nix {
        inherit disnixos tarball;
        manifest = builtins.getAttr (builtins.currentSystem) (builds.simple);
      };

      composition = import ./tests/composition.nix {
        inherit disnixos tarball;
        manifest = builtins.getAttr (builtins.currentSystem) (builds.composition);
      };

      lookup = import ./tests/lookup.nix {
        inherit disnixos tarball;
        manifest = builtins.getAttr (builtins.currentSystem) (builds.lookup);
      };

      loadbalancing = import ./tests/loadbalancing.nix {
        inherit disnixos tarball;
        manifest = builtins.getAttr (builtins.currentSystem) (builds.loadbalancing);
      };

      cyclic = import ./tests/cyclic.nix {
        inherit disnixos tarball;
        manifest = builtins.getAttr (builtins.currentSystem) (builds.cyclic);
      };
    };
  };
in
jobs
