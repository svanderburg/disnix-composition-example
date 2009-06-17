package org.nixos.disnix.example.helloworld;
import java.util.*;

public class HelloWorldService
{
	private HelloServiceConnector connector;
	
	public HelloWorldService() throws Exception
	{
		/* Read the target end point reference of the hello service from the properties file */
		Properties props = new Properties();
		props.load(this.getClass().getResourceAsStream("helloworldservice.properties"));
		String targetEPR = props.getProperty("helloservice.targetEPR");
		
		/* Create a connector object */
		connector = new HelloServiceConnector(targetEPR);
	}
	
	public String getHelloWorld() throws Exception
	{
		return connector.getHello() + " world!";
	}
}
