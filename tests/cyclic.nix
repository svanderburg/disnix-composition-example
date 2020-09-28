{disnixos, tarball, manifest}:

disnixos.disnixTest {
  name = "disnix-composition-example-cyclic-test";
  inherit tarball manifest;
  networkFile = "deployment/DistributedDeployment/network.nix";
  testScript =
    ''
      test1.wait_for_file("/var/tomcat/webapps/HelloWorldCycle")
      result = test1.succeed(
          "sleep 30; curl --fail http://test1:8080/HelloWorldCycle/index.jsp"
      )

      # The entry page should contain Hello World

      if "Hello world" in result:
          print("Entry page contains: Hello world!")
      else:
          raise Exception("Entry page should contain Hello world!")

      test3.succeed("firefox http://test1:8080/HelloWorldCycle &")
      test3.wait_for_window("Firefox")
      test3.succeed("sleep 30")
      test3.screenshot("screen")
    '';
}
