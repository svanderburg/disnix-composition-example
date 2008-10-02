rec {
  findTarget = {distribution, serviceName}:
    if distribution == [] then abort "Target not found!" else
    ( 
      if (builtins.head distribution).service.name == serviceName
      then (builtins.head distribution).target
      else findTarget { distribution = builtins.tail distribution; inherit serviceName; }
    );
}
