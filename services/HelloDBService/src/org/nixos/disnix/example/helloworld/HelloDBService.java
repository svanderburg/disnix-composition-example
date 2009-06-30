package org.nixos.disnix.example.helloworld;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;
import org.apache.axis2.*;
import org.apache.axis2.context.*;
import org.apache.axis2.service.*;

/**
 * A trivial example web service which only purpose is to say 'Hello'.
 * This HelloService variant uses a database in which the 'Hello' string is stored.
 */
public class HelloDBService implements Lifecycle
{
	/** Connection to the database */
	private Connection connection;
	
	/**
	 * @see Lifecycle#init(ServiceContext)
	 */
	@Override
	public void init(ServiceContext context) throws AxisFault
	{
		try
		{
			/* Read the JNDI name of the database from the properties file */
			Properties props = new Properties();
			props.load(getClass().getResourceAsStream("hellodb.properties"));
			String jndiName = props.getProperty("JNDI");
			
			/* 
			 * Fetch the database connection from the application server
			 * by using the JNDI interface
			 */
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup(jndiName);
			connection = ds.getConnection();
		}
		catch(Exception ex)
		{
			/* Throw an error to the user if something goes wrong with the initialization */
			throw new AxisFault(ex.toString());
		}
	}
	
	/**
	 * @see Lifecycle#destroy(ServiceContext)
	 */
	@Override
	public void destroy(ServiceContext context)
	{
		try
		{
			/* Cleanup the database connection and return it to the connection pool */			
			connection.close();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}

	/**
	 * Returns the string 'Hello', which is queried from the database
	 * 
	 * @return Hello string
	 */
	public String getHello() throws Exception
	{
		/* Query the hello string from the database */
		Statement stmt = connection.createStatement();
		ResultSet result = stmt.executeQuery("select hello from hello");
		
		if(result.next())
			return result.getString(1); // Return the queried hello string
		else
			throw new Exception("No records found"); // Return an exception if there are no records in the database
	}
}
