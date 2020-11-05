#!/bin/sh -e

for type in simple composition lookup loadbalancing cyclic
do
    dydisnix-visualize-services -s ../deployment/DistributedDeployment/services-$type.nix > architecture-$type.dot
    dot -Tpng architecture-$type.dot -o architecture-$type.png
done
