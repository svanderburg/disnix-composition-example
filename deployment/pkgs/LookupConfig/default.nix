{stdenv, libxslt, distribution}:

let
  /* 
   * Creates a list of service name, target hostname and tomcat ports
   * for each entry from the distribution model
   */
  mapping = map (distributionItem: 
                 { service = distributionItem.service.name;
		   target = distributionItem.target.hostname;
		   tomcatPort = if distributionItem.target ? tomcatPort then distributionItem.target.tomcatPort else 8080;
		 }) distribution;
  
  /* Creates an XML representation of the mapping created above */
  mappingXML = builtins.toXML mapping;
  
  /*
   * XSL stylesheet which transforms the distribution model to
   * a XML file which the lookup service understands
   */
  transformXSL = ./transform.xsl;
in
stdenv.mkDerivation {
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
