{stdenv, apacheAnt, jdk, axis2}:
{HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService";
  src = ../../../services/HelloWorldService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase =
    (if HelloService == null then "" else ''
        # Write the connection settings of the HelloService to a properties file
        echo "helloservice.targetEPR=http://${HelloService.target.properties.hostname}:${toString HelloService.target.container.axis2Port}/axis2/services/${HelloService.name}" > src/org/nixos/disnix/example/helloworld/helloworldservice.properties
      '') +
    ''
      # Workaround for org.apache.axis2.AxisFault: The server did not recognise the action which it received
      sed -i -e '/options.setTo(targetEPR);/ a options.setAction("urn:getHello");' src/org/nixos/disnix/example/helloworld/HelloServiceConnector.java

      # Generate the Axis2 application archive
      ant generate.service.aar
    '';
  installPhase = ''
    mkdir -p $out/webapps/axis2/WEB-INF/services
    cp bin/WEB-INF/services/*.aar $out/webapps/axis2/WEB-INF/services
  '';
}
