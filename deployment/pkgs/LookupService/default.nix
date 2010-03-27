{stdenv, apacheAnt, axis2, LookupConfig}:

stdenv.mkDerivation {
  name = "LookupService";
  src = ../../../services/LookupService;
  buildInputs = [ apacheAnt ];
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
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
