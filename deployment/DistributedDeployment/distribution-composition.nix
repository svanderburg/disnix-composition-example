/*
 * This Nix expression maps services from a service Nix expression to 
 * machines described in an infrastructure Nix expression.
 */
{infrastructure}:

{
  HelloMySQLDB = [ infrastructure.test2 ];
  HelloDBService = [ infrastructure.test1 ];
  HelloWorldService = [ infrastructure.test2 ];
  HelloWorld = [ infrastructure.test1 ];
}
