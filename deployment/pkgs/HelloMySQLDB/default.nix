{stdenv}:

stdenv.mkDerivation {
  name = "HelloMySQLDB";
  src = ../../../services/HelloMySQLDB;
  installPhase = ''
    mkdir -p $out/mysql-databases
    cp -v *.sql $out/mysql-databases
  '';
}
