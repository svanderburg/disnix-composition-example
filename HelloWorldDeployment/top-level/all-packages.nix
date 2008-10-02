let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { };
in
with pkgs;

rec
{
    HelloService = import ../services/HelloService {
        inherit stdenv fetchsvn jdk apacheAnt axis2;
    };
    
    HelloWorldService = import ../services/HelloWorldService {
        inherit stdenv fetchsvn jdk apacheAnt axis2;
    };
}
