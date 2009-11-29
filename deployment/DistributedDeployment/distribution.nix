/*
 * This Nix expression maps services from a service Nix expression to 
 * machines described in an infrastructure Nix expression.
 */
{infrastructure}:

{
  HelloService = [ infrastructure.test1 infrastructure.test2 ];
  HelloWorldService = [ infrastructure.test2 ];
}
