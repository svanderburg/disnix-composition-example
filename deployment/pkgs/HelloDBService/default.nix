{stdenv, apacheAnt, axis2}:

stdenv.mkDerivation {
  name = "HelloDBService";
  src = ../../../services/HelloDBService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = ''ant generate.service.aar'';
  installPhase = ''
    ensureDir $out/webapps/axis2/WEB-INF/services
    cp *.aar $out/webapps/axis2/WEB-INF/services
  '';    
}
