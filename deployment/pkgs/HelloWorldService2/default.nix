{stdenv, apacheAnt, jdk8, axis2}:
{LookupService ? null, HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService2";
  src = ../../../services/HelloWorldService2;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = (if LookupService == null then "" else ''
      # Write the connection settings of the LookupService to a properties file
      ( echo "lookupservice.targetEPR=http://${LookupService.target.properties.hostname}:${toString LookupService.target.container.tomcatPort}/${LookupService.name}/services/${LookupService.name}" 
        echo "helloservice.identifier=${HelloService.name}" ) > src/org/nixos/disnix/example/helloworld/helloworldservice2.properties
    '') +
  ''
    # Generate the webapplication archive
    ant generate.war
  '';
  installPhase = ''
    mkdir -p $out/webapps
    cp *.war $out/webapps
  '';
}
