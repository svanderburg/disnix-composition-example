{stdenv, axis2, dysnomia, stateDir}:
{tomcatInstanceSuffix ? "", instanceSuffix ? "", axis2Port ? 8080}:

let
  instanceName = "axis2${instanceSuffix}";

  catalinaBaseDir = "${stateDir}/tomcat${tomcatInstanceSuffix}";

  axis2BaseDir = "${catalinaBaseDir}/webapps/${instanceName}/WEB-INF/services";

  pkg = stdenv.mkDerivation {
    inherit (axis2) name;

    buildCommand = ''
      mkdir -p $out/webapps
      ln -s ${axis2}/webapps/axis2.war $out/webapps/${instanceName}.war

      # Add Dysnomia container configuration file for Axis2 webservices
      mkdir -p $out/etc/dysnomia/containers
      cat > $out/etc/dysnomia/containers/axis2-webservice${instanceSuffix} <<EOF
      catalinaBaseDir=${catalinaBaseDir}
      axis2BaseDir=${axis2BaseDir}
      axis2Port=${toString axis2Port}
      timeout=30
      EOF

      # Copy the Dysnomia module that manages Axis2 web services
      mkdir -p $out/libexec/dysnomia
      ln -s ${dysnomia}/libexec/dysnomia/axis2-webservice $out/libexec/dysnomia
    '';
  };
in
{
  name = instanceName;
  inherit pkg catalinaBaseDir axis2BaseDir axis2Port;
  providesContainer = "axis2-webservice";
  type = "tomcat-webapplication";
}
