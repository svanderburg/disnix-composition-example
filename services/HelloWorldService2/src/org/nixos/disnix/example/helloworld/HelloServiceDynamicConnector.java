package org.nixos.disnix.example.helloworld;

import javax.xml.namespace.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

public class HelloServiceDynamicConnector
{
	private static final String NAME_SPACE = "http://helloworld.example.disnix.nixos.org";
	
	private RPCServiceClient lookupServiceClient;
	
	public HelloServiceDynamicConnector(String lookupServiceURL) throws Exception
	{
		lookupServiceClient = new RPCServiceClient();
		Options options = lookupServiceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(lookupServiceURL);
		options.setTo(targetEPR);
	}
	
	private RPCServiceClient createRPCService(String name) throws Exception
	{
		/* Receive URL of HelloService from the LookupService */
		QName operation = new QName(NAME_SPACE, "getServiceURL");
		Object[] args_param = { name };
		Class<?>[] returnTypes = { String.class };
		Object[] response = lookupServiceClient.invokeBlocking(operation, args_param, returnTypes);
		String helloServiceURL = (String)response[0];
		
		/* Create a RPC service client instance for the received Hello Service URL */
		RPCServiceClient serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(helloServiceURL);
		options.setTo(targetEPR);
		
		/* Return the RPC service client instance */
		return serviceClient;
	}
	
	public String getHello() throws Exception
	{
		RPCServiceClient serviceClient = createRPCService("HelloService");
		
		QName operation = new QName(NAME_SPACE, "getHello");
		Object[] args_param = {};
		Class<?>[] returnTypes = { String.class };
		Object[] response = serviceClient.invokeBlocking(operation, args_param, returnTypes);
		return (String)response[0];
	}
}
