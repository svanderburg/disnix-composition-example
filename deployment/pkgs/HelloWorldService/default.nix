{stdenv, apacheAnt, axis2}:
{HelloService ? null}:

stdenv.mkDerivation {
  name = "HelloWorldService";
  src = ../../../services/HelloWorldService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/share/java/axis2";
  buildPhase =
    (if HelloService == null then "" else ''
        # Write the connection settings of the HelloService to a properties file
        echo "helloservice.targetEPR=http://${HelloService.target.hostname}:${toString HelloService.target.tomcatPort}/axis2/services/${HelloService.name}" > src/org/nixos/disnix/example/helloworld/helloworldservice.properties
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
