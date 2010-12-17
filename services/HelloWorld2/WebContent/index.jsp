<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.*"
         import="org.nixos.disnix.example.helloworld.*" %>
<%
/* Read the target end point reference of the lookup service from the properties file */
Properties props = new Properties();
props.load(this.getClass().getResourceAsStream("/org/nixos/disnix/example/helloworld/helloworld2.properties"));
String targetEPR = props.getProperty("lookupservice.targetEPR");
String helloWorldServiceIdentifier = props.getProperty("helloworldservice.identifier");

/* Create a connector object */
HelloWorldServiceDynamicConnector connector = new HelloWorldServiceDynamicConnector(targetEPR, helloWorldServiceIdentifier);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Dynamic Hello World Example!</title>
	</head>
	<body>
		<h1>Dynamic Hello World Example</h1>		
		<p><%= connector.getHelloWorld() %></p>
	</body>
</html>
