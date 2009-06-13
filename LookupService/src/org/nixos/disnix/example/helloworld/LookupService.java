package org.nixos.disnix.example.helloworld;

import java.util.*;
import org.apache.axiom.om.*;
import org.apache.axiom.om.impl.builder.*;
import org.apache.axiom.om.xpath.*;

public class LookupService
{
	private OMElement documentElement;
	
	public LookupService() throws Exception
	{
		StAXOMBuilder builder = new StAXOMBuilder(getClass().getResourceAsStream("lookupserviceconfig.xml"));
		documentElement = builder.getDocumentElement();
	}
	
	public String getServiceURL(String name) throws Exception
	{
		AXIOMXPath xpathGetURL = new AXIOMXPath("/lookupservice/service[name=\""+name+"\"]/URL");
		OMElement element = (OMElement)xpathGetURL.selectSingleNode(documentElement);
		return element.getText();
	}
}
