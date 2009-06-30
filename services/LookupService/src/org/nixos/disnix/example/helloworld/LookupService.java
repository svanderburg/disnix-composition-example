package org.nixos.disnix.example.helloworld;

import org.apache.axiom.om.*;
import org.apache.axiom.om.impl.builder.*;
import org.apache.axiom.om.xpath.*;

/**
 * Provides locations for web services.
 * 
 * This web service is just a trivial example of a lookup service
 * and should not be used in real production environments.
 * There are, of course, more sophisticated solutions available to do this.
 */
public class LookupService
{
	/** The root element of the XML document that contains the locations */
	private OMElement documentElement;
	
	/**
	 * Creates a new LookupService instance
	 * 
	 * @throws Exception If some error occurs
	 */
	public LookupService() throws Exception
	{
		/* Create a builder for XML configuration file */ 
		StAXOMBuilder builder = new StAXOMBuilder(getClass().getResourceAsStream("lookupserviceconfig.xml"));
		
		/* Provide a pointer to the root element of the configuration XML document */
		documentElement = builder.getDocumentElement();
	}
	
	/**
	 * Returns the URL of the target end point for a given web service
	 * 
	 * @param name Name of the web service
	 * @return URL of the target end point
	 * @throws Exception If some error occurs or when the web service cannot be found 
	 */
	public String getServiceURL(String name) throws Exception
	{
		/* 
		 * Execute an XPath query which selects the location of the
		 * given web service from the XML configuration file
		 */
		AXIOMXPath xpathGetURL = new AXIOMXPath("/lookupservice/service[name=\""+name+"\"]/URL");
		
		/* Return the first possible URL of the selection */
		OMElement element = (OMElement)xpathGetURL.selectSingleNode(documentElement);
		return element.getText();
	}
}
