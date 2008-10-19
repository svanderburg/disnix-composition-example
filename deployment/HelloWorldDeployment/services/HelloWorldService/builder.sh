source $stdenv/setup

# Fix the permissions of the source code

cp -av $src/* .
find . -type f | while read i
do
    chmod 644 "$i"
done
find . -type d | while read i
do
    chmod 755 "$i"
done

# Set Ant file parameters

export AXIS2_LIB=$axis2/webapps/axis2/WEB-INF/lib

# Generate connection settings for the HelloService

echo "helloservice.targetEPR=http://$HelloServiceHostname:$HelloServicePort/axis2/services/HelloService" > src/org/nixos/disnix/example/helloworld/helloworldservice.properties

# Compile, package and deploy

ant generate.service.aar
ensureDir $out/webapps/axis2/WEB-INF/services
cp HelloWorldService.aar $out/webapps/axis2/WEB-INF/services
