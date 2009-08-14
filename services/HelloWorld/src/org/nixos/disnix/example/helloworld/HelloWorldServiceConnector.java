package org.nixos.disnix.example.helloworld;
import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

/**
 * Provides an one-on-one interface to the HelloWorld WebService
 */
public class HelloWorldServiceConnector
{
	/** Service client that sends all requests to the HelloWorld WebService */
	private RPCServiceClient serviceClient;
	
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://helloworld.example.disnix.nixos.org";
	
	/**
	 * Creates a new HelloWorldService connector instance.
	 * 
	 * @param serviceURL URL of the target end point of the HelloWorldService
	 */
	public HelloWorldServiceConnector(String serviceURL) throws Exception
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	/**
	 * Retrieves the 'Hello world!' string from the HelloWorld WebService
	 * 
	 * @return Hello world string
	 * @throws AxisFault If the request fails
	 */
	public String getHelloWorld() throws AxisFault
	{
		QName operation = new QName(NAME_SPACE, "getHelloWorld");
		Object[] args_param = {};
		Class<?>[] returnTypes = { String.class };
		Object[] response = serviceClient.invokeBlocking(operation, args_param, returnTypes);
		return (String)response[0];
	}
}
