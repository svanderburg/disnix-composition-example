{stdenv, apacheAnt, axis2, jdk8, LookupConfig}:

stdenv.mkDerivation {
  name = "LookupService2";
  src = ../../../services/LookupService2;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = 
    /* If there is a generated configuration file, use this one instead of the default */
    (if LookupConfig == null then "" else ''
      cp ${LookupConfig}/lookupserviceconfig.xml src/org/nixos/disnix/example/helloworld
    '') +
    /* Create a WAR file */
    ''
      ant generate.war
    '';
  installPhase = ''
    mkdir -p $out/webapps
    cp *.war $out/webapps
  '';
}
