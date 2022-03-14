{stdenv, apacheAnt, jdk8, axis2}:
{HelloWorldService ? null, LookupService ? null}:

stdenv.mkDerivation {
  name = "HelloWorld2";
  src = ../../../services/HelloWorld2;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase =
    (if LookupService == null then "" else ''
        # Write the connection settings of the LookupService to a properties file
        ( echo "lookupservice.targetEPR=http://${LookupService.target.properties.hostname}:${toString LookupService.target.container.tomcatPort}/${LookupService.name}/services/${LookupService.name}"
          echo "helloworldservice.identifier=${HelloWorldService.name}" ) > src/org/nixos/disnix/example/helloworld/helloworld2.properties
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
