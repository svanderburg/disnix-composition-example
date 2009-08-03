{stdenv, libxslt, distribution}:

let
  /* Inherit some builtin functions for simplicity */
  inherit (builtins) toXML head tail;
  
  /* Function that filters all the Axis2 services from the distribution model */
  filterAxis2WebServices = distribution:
    if distribution == [] then []
    else
      if (head distribution).service.type == "axis2-webservice" then
        [ (head distribution) ] ++ filterAxis2WebServices (tail distribution)
      else filterAxis2WebServices (tail distribution)
  ;

  /* 
   * Creates a list of service name, target hostname and tomcat ports
   * for each entry of the Axis2 webservice type from the distribution model
   */
  mapping = map (distributionItem: 
                 { service = distributionItem.service.name;
		   target = distributionItem.target.hostname;
		   tomcatPort = if distributionItem.target ? tomcatPort then distributionItem.target.tomcatPort else 8080;
		 }) (filterAxis2WebServices distribution);
  
  /* Creates an XML representation of the mapping created above */
  mappingXML = toXML mapping;
  
  /*
   * XSL stylesheet which transforms the distribution model to
   * a XML file which the lookup service understands
   */
  transformXSL = ./transform.xsl;
in
stdenv.mkDerivation {
  name = "LookupConfig";
  
  /* 
   * Use the given stylesheet to transform the mapping XML to a XML config file
   * the lookup service understands
   */
  buildCommand = ''
    ensureDir $out
    
    cat > mapping.xml <<EOF
    ${mappingXML}
    EOF
    
    xsltproc ${transformXSL} mapping.xml > $out/lookupserviceconfig.xml
  '';
  
  buildInputs = [ libxslt ];
}
