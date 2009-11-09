name "master"
description "Server setup for chef behind a proxy, and ldap"

recipes "chef::server_proxy", "openldap::server", "apache2::mod_authnz_ldap"

override_attributes({
  "chef" => { 
    "server_ssl_req" => "/C=US/ST=Several/L=Locality/O=EC2/OU=Operations/CN=chef.example/emailAddress=ops@example.com",
    "authorized_openid_providers" => ["myopenid.com"],
    "authorized_openid_identifiers" => ["example.myopenid.com"],
    "server_version" => "0.7.14"
  },
  "openldap" => {
    "server" => "chef.example",
    "slapd_type" => "master",
    "rootpw" => "{SSHA}--password--"
  },
  "iptables" => {
    "all" => [80, 443, 444],
    "internal" => [389]
  }
})
