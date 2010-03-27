{stdenv, apacheAnt, axis2}:
{HelloWorldService ? null, LookupService ? null}:

stdenv.mkDerivation {
  name = "HelloWorld2";
  src = ../../../services/HelloWorld2;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase =
    (if LookupService == null then "" else ''
        # Write the connection settings of the LookupService to a properties file
        ( echo "lookupservice.targetEPR=http://${LookupService.target.hostname}:${toString LookupService.target.tomcatPort}/${LookupService.name}/services/${LookupService.name}"
	  echo "helloworldservice.identifier=${HelloWorldService.name}" ) > src/org/nixos/disnix/example/helloworld/helloworld2.properties
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
