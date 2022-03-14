{stdenv, apacheAnt, jdk8, axis2}:

stdenv.mkDerivation {
  name = "HelloService";
  src = ../../../services/HelloService;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    mkdir -p $out/webapps
    cp *.war $out/webapps
  '';
}
