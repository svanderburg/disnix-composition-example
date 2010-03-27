{stdenv, apacheAnt, axis2}:
{LookupService ? null, HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService2";
  src = ../../../services/HelloWorldService2;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = (if LookupService == null then "" else ''
      # Write the connection settings of the LookupService to a properties file
      ( echo "lookupservice.targetEPR=http://${LookupService.target.hostname}:${toString LookupService.target.tomcatPort}/${LookupService.name}/services/${LookupService.name}" 
        echo "helloservice.identifier=${HelloService.name}" ) > src/org/nixos/disnix/example/helloworld/helloworldservice2.properties
    '') +
  ''
    # Generate the webapplication archive
    ant generate.war
  '';
  installPhase = ''
    ensureDir $out/webapps/axis2
    cp *.war $out/webapps/axis2
  '';
}
