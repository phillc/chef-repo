name "cache"
description "Sets up a caching server. Its domain name in the fqdn determines who it caches for."

recipes "varnish"

default_attributes(
  "iptables" => {
    "all" => [80],
    "domain" => {
      "app" => [6082]
    }
  }
)