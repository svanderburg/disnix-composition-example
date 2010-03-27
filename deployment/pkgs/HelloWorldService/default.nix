{stdenv, apacheAnt, axis2}:
{HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService";
  src = ../../../services/HelloWorldService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase =
    (if HelloService == null then "" else ''
        # Write the connection settings of the HelloService to a properties file
        echo "helloservice.targetEPR=http://${HelloService.target.hostname}:${toString HelloService.target.tomcatPort}/${HelloService.name}/services/${HelloService.name}" > src/org/nixos/disnix/example/helloworld/helloworldservice.properties
      '') +
    ''
      # Generate the webapplication archive
      ant generate.war
    '';
  installPhase = ''    
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
