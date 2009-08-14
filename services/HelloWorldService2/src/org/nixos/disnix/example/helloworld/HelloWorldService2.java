package org.nixos.disnix.example.helloworld;
import java.util.*;

/**
 * A trivial web service which only purpose is to say 'Hello world!'.
 * This web service invokes a HelloService instance to retrieve the 'Hello' string,
 * then it uses the retrieved string to compose the phrase 'Hello world!'.
 * 
 * This variant of the HelloWorldService invokes a LookupService instance which
 * provides the location of the HelloService, so that the binding of
 * the services can be done at runtime, instead of deployment time.
 */
public class HelloWorldService2
{
	/** Interface that sends requests to the HelloService */
	private HelloServiceDynamicConnector connector;
	
	/**
	 * Creates a new HelloWorldService2 instance
	 * 
	 * @throws Exception If some error occurs
	 */
	public HelloWorldService2() throws Exception
	{
		/* Read the target end point reference of the lookup service from the properties file */
		Properties props = new Properties();
		props.load(this.getClass().getResourceAsStream("helloworldservice2.properties"));
		String targetEPR = props.getProperty("lookupservice.targetEPR");
		
		/* Create a connector object */
		connector = new HelloServiceDynamicConnector(targetEPR);
	}
	
	/**
	 * Returns the string 'Hello world!'
	 * 
	 * @return Hello world string
	 * @throws Exception If some error occurs
	 */
	public String getHelloWorld() throws Exception
	{
		return connector.getHello() + " world!";
	}
}
