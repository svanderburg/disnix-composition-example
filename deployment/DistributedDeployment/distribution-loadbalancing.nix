/*
 * This Nix expression maps services from a service Nix expression to 
 * machines described in an infrastructure Nix expression.
 */
{infrastructure}:

{
  LookupService2 = [ infrastructure.test2 ];
  HelloService = [ infrastructure.test1 infrastructure.test2 ]; # Multiple instances of the HelloService
  HelloWorldService2 = [ infrastructure.test2 ];
  HelloWorld2 = [ infrastructure.test1 ];
}
