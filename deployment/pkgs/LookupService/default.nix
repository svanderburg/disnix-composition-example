{stdenv, apacheAnt, axis2, LookupConfig}:

stdenv.mkDerivation {
  name = "LookupService";
  src = ../../../services/LookupService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = 
    /* If there is a generated configuration file, use this one instead of the default */
    (if LookupConfig == null then "" else ''
      cp ${LookupConfig}/lookupserviceconfig.xml src/org/nixos/disnix/example/helloworld
    '') +
    /* Create a service AAR file */
    ''
      ant generate.service.aar
    '';
  installPhase = ''
    ensureDir $out/webapps/axis2/WEB-INF/services
    cp *.aar $out/webapps/axis2/WEB-INF/services
  '';
}
