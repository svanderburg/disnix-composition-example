{stdenv, apacheAnt, axis2}:

stdenv.mkDerivation {
  name = "LookupService";
  src = ../../../services/LookupService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/share/java/axis2";
  buildPhase = ''
    ant generate.service.aar
  '';
  installPhase = ''
    ensureDir $out/webapps/axis2/WEB-INF/services
    cp *.aar $out/webapps/axis2/WEB-INF/services
  '';
}
