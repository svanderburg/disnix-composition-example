{infrastructure}:

{
  tomcat = [ infrastructure.test1 infrastructure.test2 ];
  axis2 = [ infrastructure.test2 ];

  HelloService = [ infrastructure.test2 ];
  HelloWorldService = [ infrastructure.test2 ];
  HelloWorld = [ infrastructure.test1 ];
}
