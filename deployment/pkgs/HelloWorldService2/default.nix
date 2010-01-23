{stdenv, apacheAnt, axis2}:
{LookupService ? null, HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService2";
  src = ../../../services/HelloWorldService2;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = (if LookupService == null then "" else ''
      # Write the connection settings of the LookupService to a properties file
      ( echo "lookupservice.targetEPR=http://${LookupService.target.hostname}:${toString LookupService.target.tomcatPort}/axis2/services/${LookupService.name}" 
        echo "helloservice.identifier=${HelloService.name}" ) > src/org/nixos/disnix/example/helloworld/helloworldservice2.properties
    '') +
  ''
    # Generate the webapplication archive
    ant generate.service.aar
  '';
  installPhase = ''
    ensureDir $out/webapps/axis2/WEB-INF/services
    cp *.aar $out/webapps/axis2/WEB-INF/services
  '';
}
