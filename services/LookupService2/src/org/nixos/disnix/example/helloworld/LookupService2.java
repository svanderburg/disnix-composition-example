package org.nixos.disnix.example.helloworld;

import org.apache.axiom.om.*;
import org.apache.axiom.om.impl.builder.*;
import java.util.*;

/**
 * Provides locations for web services. This variant supports load
 * balancing by using the round robin scheduling method.
 * 
 * This web service is just a trivial example of a lookup service
 * and should not be used in real production environments.
 * There are, of course, more sophisticated solutions available to do this.
 */
public class LookupService2
{	
	/** Hash map which maps service names on location URLs */
	private HashMap<String, ArrayList<String>> locations;
	
	/**
	 * Creates a new LookupService instance
	 * 
	 * @throws Exception If some error occurs
	 */
	public LookupService2() throws Exception
	{
		/* Create a builder for XML configuration file */ 
		StAXOMBuilder builder = new StAXOMBuilder(getClass().getResourceAsStream("lookupserviceconfig.xml"));
		
		/* Provide a pointer to the root element of the configuration XML document */
		OMElement documentElement = builder.getDocumentElement();
		
		/* Initialize the hash map */
		locations = new HashMap<String, ArrayList<String>>();
		
		/* 
		 * Iterate over all the mappings and store them in a hash map
		 * for convenience
		 */		
		Iterator<OMElement> servicesIterator = documentElement.getChildElements();

		while(servicesIterator.hasNext())
		{
			OMElement serviceElement = servicesIterator.next();
			
			Iterator<OMElement> iterator = serviceElement.getChildElements();
			String name = "";
			String url = "";
			
			/* 
			 * Iterate over all sub elements of a service, which is
			 * a 'name' and an 'URL' element and put them in strings
			 */
			while(iterator.hasNext())
			{
				OMElement element = iterator.next();
				
				if(element.getLocalName().equals("name"))
					name = element.getText();
				else if(element.getLocalName().equals("URL"))
					url = element.getText();
			}
			
			/* Put the retrieved service in the hash map */
			putServiceElementInHashMap(name, url);
		}
	}
	
	/**
	 * Adds a service element in the hash map. If the keys
	 * exists it will be stored in a list. Otherwise
	 * a new list is created and with the given URL.
	 * 
	 * @param name Name of the web service
	 * @param url URL of the web service
	 */
	private void putServiceElementInHashMap(String name, String url)
	{		
		if(locations.containsKey(name))
		{
			/* 
			 * If the key already exists, put the location in
			 * the list
			 */
			ArrayList<String> urls = locations.get(name);
			urls.add(url);
		}
		else
		{
			/*
			 * If the key does not exists, create a new empty
			 * list and put the given URL to it
			 */
			ArrayList<String> urls = new ArrayList<String>();
			urls.add(url);
			locations.put(name, urls);
		}
	}
	
	/**
	 * Returns the URL of the target end point for a given web service
	 * 
	 * @param name Name of the web service
	 * @return URL of the target end point
	 * @throws Exception If some error occurs or when the web service cannot be found 
	 */
	public synchronized String getServiceURL(String name) throws Exception
	{
		/* Retrieve location list from the hash map */
		ArrayList<String> urls = locations.get(name);
		
		/* Retrieve the first location from the list */
		String url = urls.remove(0);
		
		/* Put the retrieved URL to the end of the list */
		urls.add(url);
		
		/* Return the retrieved URL */
		return url;
	}
}
