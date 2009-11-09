name "base"
description "Configure the environment."

default_attributes(
  "chef" => {
    "server_fqdn" => "chef.example",
    "url_type" => "https",
    "client_version" => "0.7.14"
  },
  "openldap" => {
    "server" => "chef.example",
    "basedn" => "dc=master"
  },
  "ssh" => {
    "port" => "3000" # change this
  }
)

recipes "ubuntu", "build-essential", "git", "internal_ip", "hosts", "ssh_known_hosts", "sudo", "openldap::auth", "ssh", "iptables::secure", "chef::client"
