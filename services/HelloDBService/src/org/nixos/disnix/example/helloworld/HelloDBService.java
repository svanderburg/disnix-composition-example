package org.nixos.disnix.example.helloworld;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

public class HelloDBService
{
	private Connection connection;
	
	public HelloDBService() throws Exception
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
	
	public String getHello() throws Exception
	{
		Statement stmt = connection.createStatement();
		ResultSet result = stmt.executeQuery("select hello from hello");
		
		if(result.next())
			return result.getString(1);
		else
			throw new Exception("No records found.");
	}	
}
