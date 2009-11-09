name "app"
description "App server for the --domain-- website. Apache + passenger"

recipes "railsapp"

default_attributes(
  "railsapp" => {
    "apache" => {
      "listen_ports" => ["80"]
    },
    "app_name" => "--domain--",
    "db" => { # change this
      "host" => "127.0.0.1",
      "database" => "--domain--_production",
      "user" => "",
      "password" => ""
    },
    "repository" => "---git repository---",
    "branch" => "production",
    "user" => {
      "name" => "web",
      "pubkey" => "ssh-rsa ... ==",
      "privatekey" => "-----BEGIN RSA PRIVATE KEY-----...==
-----END RSA PRIVATE KEY-----"
    }
  },
  "iptables" => {
    "domain" => {
      "cache" => [80]
    }
  }
)
