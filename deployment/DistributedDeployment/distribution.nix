/*
 * This Nix expression maps services from a service Nix expression to 
 * machines described in an infrastructure Nix expression.
 */
{services, infrastructure}:

[
  { service = services.HelloService; target = infrastructure.test1; }
  { service = services.HelloWorldService; target = infrastructure.test2; }
  { service = services.HelloWorldService; target = infrastructure.test1; }
  { service = services.LookupService; target = infrastructure.test2; }
  { service = services.MySQLService; target = infrastructure.test1; }
  { service = services.HelloDBService; target = infrastructure.test1; }
]
