{stdenv, apacheAnt, jdk8, axis2}:

stdenv.mkDerivation {
  name = "HelloService";
  src = ../../../services/HelloService;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.service.aar";
  installPhase = ''
    mkdir -p $out/webapps/axis2/WEB-INF/services
    cp bin/WEB-INF/services/*.aar $out/webapps/axis2/WEB-INF/services
  '';
}
