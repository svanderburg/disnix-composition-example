/*
 * This Nix expression maps services from a service Nix expression to 
 * machines described in an infrastructure Nix expression.
 */
{infrastructure}:

{
  HelloService = [ infrastructure.test1 ];
  HelloWorldService = [ infrastructure.test2 ];
  HelloWorld = [ infrastructure.test1 ];
}
