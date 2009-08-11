{stdenv, HelloDBService}:
{HelloMySQLDB ? null}:

let
  mysqlHostname = if HelloMySQLDB == null then "localhost" else HelloMySQLDB.target.hostname;
  mysqlPort = if HelloMySQLDB == null then 3306 else if HelloMySQLDB.target.mysqlPort == null then 3306 else HelloMySQLDB.target.mysqlPort;
in
stdenv.mkDerivation {
  name = "HelloDBServiceWrapper";
  buildCommand = ''
    ensureDir $out/conf/Catalina
    cat > $out/conf/Catalina/axis2.xml <<EOF
    <Context>
      <Resource name="jdbc/HelloDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="root" password="" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${mysqlHostname}:${toString mysqlPort}/hello?autoReconnect=true" />
    </Context>
    EOF
    ln -sf ${HelloDBService}/webapps $out/webapps
  '';
}
