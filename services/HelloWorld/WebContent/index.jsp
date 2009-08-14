<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.*"
         import="org.nixos.disnix.example.helloworld.*" %>
<%
/* Read the target end point reference of the hello service from the properties file */
Properties props = new Properties();
props.load(this.getClass().getResourceAsStream("/org/nixos/disnix/example/helloworld/helloworld.properties"));
String targetEPR = props.getProperty("helloworldservice.targetEPR");

/* Create a connector object */
HelloWorldServiceConnector connector = new HelloWorldServiceConnector(targetEPR);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Hello World Example!</title>
	</head>
	<body>
		<h1>Hello World Example</h1>		
		<p><%= connector.getHelloWorld() %></p>
	</body>
</html>
