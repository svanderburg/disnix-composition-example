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
                username="${HelloMySQLDB.target.container.mysqlUsername}" password="${HelloMySQLDB.target.container.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${HelloMySQLDB.target.properties.hostname}:${toString (HelloMySQLDB.target.container.mysqlPort)}/${HelloMySQLDB.name}?autoReconnect=true" />
    </Context>
    EOF
    ln -sf ${HelloDBService}/webapps $out/webapps
  '';
}
