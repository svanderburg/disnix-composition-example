package org.nixos.disnix.example.helloworld;

import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

public class HelloServiceConnector
{
	private RPCServiceClient serviceClient;
	
	private static final String NAME_SPACE = "http://helloworld.example.disnix.nixos.org";
	
	public HelloServiceConnector(String serviceURL) throws Exception
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	public String getHello() throws AxisFault
	{
		QName operation = new QName(NAME_SPACE, "getHello");
		Object[] args_param = new Object[] {};
		Class<?>[] returnTypes = new Class[] { String.class };
		Object[] response = serviceClient.invokeBlocking(operation, args_param, returnTypes);
		return (String)response[0];
	}
}
