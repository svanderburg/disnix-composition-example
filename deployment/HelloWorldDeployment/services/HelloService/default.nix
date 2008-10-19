{stdenv, fetchsvn, jdk, apacheAnt, axis2}:

stdenv.mkDerivation {
  name = "HelloService-0.1";
  src = fetchsvn {
    url = https://svn.nixos.org/repos/nix/disnix/HelloWorldExample/trunk/HelloService;
    sha256 = "83421d756e261879cf7d01e9fe7baecfcb30d88c625350a7b477f616ed80eb5e";
    rev = 12935;
  };
  builder = ./builder.sh;
  buildInputs = [apacheAnt jdk];
  inherit axis2;
}
