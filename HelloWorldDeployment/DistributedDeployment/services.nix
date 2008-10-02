{distribution}:

let lib = import ../lib;
    pkgs = import ../top-level/all-packages.nix;
in

rec {
    HelloService = {
        name = "HelloService";
        pkg = pkgs.HelloService; 
        dependsOn = [];
    };
    HelloWorldService = rec {
        name = "HelloWorldService";
        target = lib.findTarget {inherit distribution; serviceName = "HelloService";};	
        pkg = pkgs.HelloWorldService
	  {HelloServiceHostname = target.hostname; HelloServicePort = target.tomcatPort;};
        dependsOn = [ HelloService ];
    };
}
