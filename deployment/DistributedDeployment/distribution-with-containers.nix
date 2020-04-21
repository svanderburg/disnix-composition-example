{infrastructure}:

let
  applicationServicesDistribution = import ./distribution-simple.nix {
    inherit infrastructure;
  };
in
{
  simpleAppservingTomcat = [ infrastructure.test1 infrastructure.test2 ];
  mysql = [ infrastructure.test2 ];
} // applicationServicesDistribution
