{stdenv}:

stdenv.mkDerivation {
  name = "HelloMySQLDB";
  src = ../../../services/HelloMySQLDB;
  installPhase = ''
    ensureDir $out/mysql-databases
    cp -v *.sql $out/mysql-databases
  '';
}
