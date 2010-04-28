package org.nixos.disnix.example.helloworld;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

/**
 * A trivial example web service which only purpose is to say 'Hello'.
 * This HelloService variant uses a database in which the 'Hello' string is stored.
 */
public class HelloDBService
{
	/** JNDI identifier for the database connection pool */
	private String jndiName;
	
	/**
	 * Creates a new HelloDBService instance.
	 * 
	 * @throws Exception If retrieving the JNDI string fails
	 */
	public HelloDBService() throws Exception
	{
		/* Read the JNDI name of the database from the properties file */
		Properties props = new Properties();
		props.load(getClass().getResourceAsStream("hellodb.properties"));
		jndiName = props.getProperty("JNDI");
	}
	
	/** 
	 * Fetch the database connection from the application server
	 * by using the JNDI interface
	 * 
	 * @return Connection Database connection from the connection pool
	 */	
	private Connection retrieveConnection() throws Exception
	{					
		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup(jndiName);
		return ds.getConnection();
	}
		
	/**
	 * Returns the string 'Hello', which is queried from the database
	 * 
	 * @return Hello string
	 */
	public String getHello() throws Exception
	{		
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			/* Query the hello string from the database */
			Statement stmt = connection.createStatement();
			ResultSet result = stmt.executeQuery("select hello from hello");
			String hello = null;
			
			if(result.next())
				hello = result.getString(1); // Retrieve the queried hello string		
			
			if(hello == null)
				throw new Exception("No records found"); // Return an exception if there are no records in the database
			else
				return hello; // Return the hello string
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			/* Release the connection to the connection pool */
			connection.close();
		}
	}
}
