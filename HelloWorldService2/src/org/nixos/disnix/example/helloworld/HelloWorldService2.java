package org.nixos.disnix.example.helloworld;

import java.util.*;

public class HelloWorldService2
{
	private HelloServiceDynamicConnector connector;
	
	public HelloWorldService2() throws Exception
	{
		/* Read the target end point reference of the hello service from the properties file */
		Properties props = new Properties();
		props.load(this.getClass().getResourceAsStream("helloworldservice2.properties"));
		String targetEPR = props.getProperty("lookupservice.targetEPR");
		
		/* Create a connector object */
		connector = new HelloServiceDynamicConnector(targetEPR);
	}
	
	public String getHelloWorld() throws Exception
	{
		return connector.getHello() + " world!";
	}
}
