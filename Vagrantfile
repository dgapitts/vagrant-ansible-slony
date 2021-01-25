# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

# Postgres server 1.
config.vm.define "db1" do |app|
  app.vm.hostname = "pgnode1"
  app.vm.box = "geerlingguy/centos7"
  app.vm.network :private_network, ip: "192.168.60.4"
end

# Postgres server 2.
#config.vm.define "db2" do |app|
#  app.vm.hostname = "pgnode2"
#  app.vm.box = "geerlingguy/centos7"
#  app.vm.network :private_network, ip: "192.168.60.5"
#end

# Postgres server 3.
#config.vm.define "db3" do |app|
#  app.vm.hostname = "pgnode3"
#  app.vm.box = "geerlingguy/centos7"
#  app.vm.network :private_network, ip: "192.168.60.6"
#end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml" 
  end

end

