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

# Compile, package and deploy

ant generate.service.aar
ensureDir $out/webapps/axis2/WEB-INF/services
cp HelloService.aar $out/webapps/axis2/WEB-INF/services
