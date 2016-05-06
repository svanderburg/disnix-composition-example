{stdenv, apacheAnt, jdk, axis2}:
{HelloWorldService ? null}:

stdenv.mkDerivation {
  name = "HelloWorld";
  src = ../../../services/HelloWorld;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase =
    (if HelloWorldService == null then "" else ''
        # Write the connection settings of the HelloService to a properties file
        echo "helloworldservice.targetEPR=http://${HelloWorldService.target.properties.hostname}:${toString HelloWorldService.target.container.tomcatPort}/${HelloWorldService.name}/services/${HelloWorldService.name}" > src/org/nixos/disnix/example/helloworld/helloworld.properties
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
