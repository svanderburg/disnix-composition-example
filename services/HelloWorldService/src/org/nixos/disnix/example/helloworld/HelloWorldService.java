package org.nixos.disnix.example.helloworld;
import java.util.*;

/**
 * A trivial web service which only purpose is to say 'Hello world!'.
 * This web service invokes a HelloService instance to retrieve the 'Hello' string,
 * then it uses the retrieved string to compose the phrase 'Hello world!'.
 */
public class HelloWorldService
{
	/** Interface that sends requests to the HelloService */
	private HelloServiceConnector connector;
	
	/**
	 * Creates a new HelloWorldService instance.
	 * 
	 * @throws Exception If some error occurs
	 */
	public HelloWorldService() throws Exception
	{
		/* Read the target end point reference of the hello service from the properties file */
		Properties props = new Properties();
		props.load(this.getClass().getResourceAsStream("helloworldservice.properties"));
		String targetEPR = props.getProperty("helloservice.targetEPR");
		
		/* Create a connector object */
		connector = new HelloServiceConnector(targetEPR);
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
