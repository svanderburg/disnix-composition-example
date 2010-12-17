/*
 * This Nix expression maps services from a service Nix expression to 
 * machines described in an infrastructure Nix expression.
 */
{infrastructure}:

{
  LookupService = [ infrastructure.test2 ];
  HelloService = [ infrastructure.test1 ];
  HelloWorldService2 = [ infrastructure.test2 ];
  HelloWorld2 = [ infrastructure.test1 ];
}
