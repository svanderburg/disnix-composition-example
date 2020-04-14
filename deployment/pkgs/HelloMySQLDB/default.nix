{stdenv}:
{mysqlUsername, mysqlPassword}:

stdenv.mkDerivation rec {
  name = "HelloMySQLDB";
  src = ../../../services/HelloMySQLDB;
  installPhase = ''
    mkdir -p $out/mysql-databases
    (
      echo "grant all on ${name}.* to '${mysqlUsername}'@'localhost' identified by '${mysqlPassword}';"
      echo "grant all on ${name}.* to '${mysqlUsername}'@'%' identified by '${mysqlPassword}';"
      cat *.sql
      echo "flush privileges;"
    ) > $out/mysql-databases/${name}.sql
  '';
}
