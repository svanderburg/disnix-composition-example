{stdenv, apacheAnt, jdk, axis2}:

stdenv.mkDerivation {
  name = "HelloService";
  src = ../../../services/HelloService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
