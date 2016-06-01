package org.nixos.disnix.example.helloworld;
import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

/**
 * Provides an one-on-one interface to the Hello WebService.
 * 
 * This connector provides dynamic invocation, because it uses
 * a LookupService instance to retrieve the location of the HelloService,
 * which allows the location of the HelloService to be changed,
 * without redeployment.
 */
public class HelloServiceDynamicConnector
{
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://helloworld.example.disnix.nixos.org";
	
	/** Service client that sends all requests to the lookup web service */
	private RPCServiceClient lookupServiceClient;
	
	/** Identifier of the service we have to query from the lookup service */
	private String serviceName;
	
	/**
	 * URL of the target end point of the LookupService
	 * 
	 * @param lookupServiceURL URL of the target end point of the LookupService
	 * @param serviceName Identifier of the service we have to query from the lookup service
	 * @throws Exception If some error occurs
	 */
	public HelloServiceDynamicConnector(String lookupServiceURL, String serviceName) throws Exception
	{
		this.serviceName = serviceName;
		lookupServiceClient = new RPCServiceClient();
		Options options = lookupServiceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(lookupServiceURL);
		options.setTo(targetEPR);
		options.setProperty(AddressingConstants.DISABLE_ADDRESSING_FOR_OUT_MESSAGES, Boolean.TRUE);
	}
	
	/**
	 * Creates a RPCServiceClient that connects to the given web service.
	 * This method invokes the LookupService to retrieve the location
	 * of the specified web service.
	 * 
	 * @param name Name of the web service to connect to
	 * @return RPCServiceClient which connects to the given web service
	 * @throws AxisFault If some error occurs or if the web service cannot be found
	 */
	private RPCServiceClient createRPCService(String name) throws AxisFault
	{
		/* Receive URL of HelloService from the LookupService */
		QName operation = new QName(NAME_SPACE, "getServiceURL");
		Object[] args = { name };
		Class<?>[] returnTypes = { String.class };
		Object[] response = lookupServiceClient.invokeBlocking(operation, args, returnTypes);
		String helloServiceURL = (String)response[0];
		
		/* Create an RPC service client instance for the received Hello Service URL */
		RPCServiceClient serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(helloServiceURL);
		options.setTo(targetEPR);
		options.setProperty(AddressingConstants.DISABLE_ADDRESSING_FOR_OUT_MESSAGES, Boolean.TRUE);
		
		/* Return the RPC service client instance */
		return serviceClient;
	}
	
	/**
	 * Retrieves the 'hello' string from the Hello WebService
	 * 
	 * @return Hello string
	 * @throws AxisFault If the request fails
	 */
	public String getHello() throws AxisFault
	{
		RPCServiceClient serviceClient = null;
		
		try
		{
			/* Create a RPCServiceClient which connects to a HelloService instance */
			serviceClient = createRPCService(serviceName);

			/* Invoke the getHello operation on the HelloService */
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
		finally
		{
			if(serviceClient != null)
			{
				serviceClient.cleanup();
				serviceClient.cleanupTransport();
			}
		}
	}
}
