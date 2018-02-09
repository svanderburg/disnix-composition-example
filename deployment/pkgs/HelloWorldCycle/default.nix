{stdenv, apacheAnt, jdk, axis2}:
{HelloWorldCycle ? null}:

stdenv.mkDerivation {
  name = "HelloWorldCycle";
  src = ../../../services/HelloWorldCycle;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase =
    (if HelloWorldCycle == null then "" else ''
        # Write the connection settings of another HelloWorldCycle to a properties file
        echo "helloworldservice.targetEPR=http://${HelloWorldCycle.target.properties.hostname}:${toString HelloWorldCycle.target.container.tomcatPort}/HelloWorldCycle/services/HelloWorldCyclicService" > src/org/nixos/disnix/example/helloworld/helloworld.properties
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
