#!/bin/bash
passwd
hostname=`cat /etc/hostname | sed 's/\(.*\)\..*/\1/'`
sudo echo "${hostname}" > /etc/hostname

IFS=$'\n'
set $(cat /etc/hosts)

# internal ip... this will do until chef takes it over
echo "${1}
${2} ${hostname}
127.0.0.1   chef.example" > /etc/hosts # change with server ip

sudo /etc/init.d/hostname.sh stop
sudo /etc/init.d/hostname.sh start

echo "Setting up chef..."

sudo locale-gen en_US.UTF-8
sudo /usr/sbin/update-locale LANG=en_US.UTF-8

sudo apt-get -y update
sudo apt-get -y install ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb build-essential wget ssl-cert
 
cd /tmp
wget http://rubyforge.org/frs/download.php/57643/rubygems-1.3.4.tgz
tar zxf rubygems-1.3.4.tgz
cd rubygems-1.3.4
sudo ruby setup.rb --no-ri --no-rdoc
sudo ln -sfv /usr/bin/gem1.8 /usr/bin/gem
 
sudo gem source -a http://gems.opscode.com/
 
sudo gem install ohai chef --no-ri --no-rdoc
 
echo 'file_cache_path "/tmp/chef-solo"
cookbook_path "/tmp/chef-solo/cookbooks"' > /tmp/solo.rb
 
echo '{
  "bootstrap": {
    "chef": {
      "url_type": "https",
      "init_style": "none",
      "client_log": "STDOUT",
      "path": "/srv/chef",
      "serve_path": "/srv/chef",
      "server_fqdn": "chef.example",
      "server_ssl_req": "/C=US/ST=Several/L=Locality/O=EC2/OU=Operations/CN=chef.example/emailAddress=ops@example.com"
    }
  },
  "recipes": "bootstrap::client"
}' > /tmp/chef.json
 
sudo chef-solo -c /tmp/solo.rb -j /tmp/chef.json -r http://s3.amazonaws.com/chef-solo/bootstrap-0.7.12.tar.gz

chef-client
 
echo "Done! Please, register this client..."
echo "[Press any key when done]"
 
read
echo "Adding the node"
 
chef-client
 
echo "All set, you can now add a role to this node."
echo "[Press any key when done]"
 
read
echo "Configuring the node..."
 
chef-client