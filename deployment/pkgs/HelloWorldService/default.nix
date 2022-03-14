{stdenv, apacheAnt, jdk8, axis2}:
{HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService";
  src = ../../../services/HelloWorldService;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase =
    (if HelloService == null then "" else ''
        # Write the connection settings of the HelloService to a properties file
        echo "helloservice.targetEPR=http://${HelloService.target.properties.hostname}:${toString HelloService.target.container.tomcatPort}/${HelloService.name}/services/${HelloService.name}" > src/org/nixos/disnix/example/helloworld/helloworldservice.properties
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
