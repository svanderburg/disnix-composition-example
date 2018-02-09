/*
 * This Nix expression maps services from a service Nix expression to
 * machines described in an infrastructure Nix expression.
 */
{infrastructure}:

{
  HelloWorldCycle1 = [ infrastructure.test1 ];
  HelloWorldCycle2 = [ infrastructure.test2 ];
}
