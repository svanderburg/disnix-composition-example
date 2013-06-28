package org.nixos.disnix.example.helloworld;

import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

/**
 * Provides an one-on-one interface to the Hello WebService
 */
public class HelloServiceConnector
{
	/** Service client that sends all requests to the Hello WebService */
	private RPCServiceClient serviceClient;
	
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://helloworld.example.disnix.nixos.org";
	
	/**
	 * Creates a new HelloService connector instance.
	 * 
	 * @param serviceURL URL of the target end point of the HelloService
	 * @throws Exception If some error occurs
	 */
	public HelloServiceConnector(String serviceURL) throws Exception
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	/**
	 * Retrieves the 'hello' string from the Hello WebService
	 * 
	 * @return Hello string
	 * @throws AxisFault If the request fails
	 */
	public String getHello() throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "getHello");
			Object[] args = {};
			Class<?>[] returnTypes = { String.class };
			Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
			return (String)response[0];
		}
		catch(AxisFault ex)
		{
			throw ex;
		}
		/* This seems to throw an exception at the second request */
		/*finally
		{
			serviceClient.cleanup();
			serviceClient.cleanupTransport();
		}*/
	}
}
