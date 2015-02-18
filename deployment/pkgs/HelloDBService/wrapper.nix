{stdenv, HelloDBService}:
{HelloMySQLDB}:

stdenv.mkDerivation {
  name = "HelloDBServiceWrapper";
  buildCommand = ''
    mkdir -p $out/conf/Catalina
    cat > $out/conf/Catalina/HelloDBService.xml <<EOF
    <Context>
      <Resource name="jdbc/HelloMySQLDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${HelloMySQLDB.target.mysqlUsername}" password="${HelloMySQLDB.target.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${HelloMySQLDB.target.hostname}:${toString (HelloMySQLDB.target.mysqlPort)}/${HelloMySQLDB.name}?autoReconnect=true" />
    </Context>
    EOF
    ln -sf ${HelloDBService}/webapps $out/webapps
  '';
}
