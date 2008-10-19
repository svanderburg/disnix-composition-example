{stdenv, fetchsvn, jdk, apacheAnt, axis2}:
{HelloServiceHostname ? "localhost", HelloServicePort ? 8080}:

stdenv.mkDerivation {
  name = "HelloWorldService-0.1";
  src = fetchsvn {
    url = https://svn.nixos.org/repos/nix/disnix/HelloWorldExample/trunk/HelloWorldService;
    sha256 = "74f868564b7be5917a7d8adeed468cc12b892d8d977f192ef29d12a91688ec90";
    rev = 12935;
  };
  builder = ./builder.sh;
  buildInputs = [apacheAnt jdk];
  inherit axis2 HelloServiceHostname HelloServicePort;
}
