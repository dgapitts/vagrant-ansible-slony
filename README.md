## Summary

Continuing on my initial exploration of settting up slony on a single node (https://github.com/dgapitts/vagrant-pg96-slony), this new project aim to:
* replace as much as possible of the configuration to ansible (starting by installing postgres via ansible as per https://github.com/dgapitts/vagrant-ansible-for-devops)
* move on from a single host (playing master and slave) to 2 and 3 host configurations (building on top of https://github.com/dgapitts/vagrant-ansible-for-devops-3nodes)
* investigate other slony replication features e.g.monitoring and failover

So far I have:
*  complete initial single-host setup with ansible to install postgres 

Fortunately this should be easy to extend to a two host config i.e. my next step


## Highlight from initial single-node setup with ansible to install postgres 

I have attached the full log [first_build_single_node_setup.log] for this initial run setup

```
[~/projects/vagrant-ansible-slony] # vagrant destroy;vagrant up;vagrant ssh -c "sudo bash /vagrant/base_setup.sh";vagrant ssh -c "psql -d pgbenchslave -c 'select count(*) from pgbench_branches;'"
    db1: Are you sure you want to destroy the 'db1' VM? [y/N] y
==> db1: Forcing shutdown of VM...
==> db1: Destroying VM and associated drives...
Bringing machine 'db1' up with 'virtualbox' provider...
==> db1: Importing base box 'geerlingguy/centos7'...
==> db1: Matching MAC address for NAT networking...
==> db1: Checking if box 'geerlingguy/centos7' is up to date...
==> db1: Setting the name of the VM: vagrant-ansible-slony_db1_1611569671394_70281
==> db1: Clearing any previously set network interfaces...
[~/projects/vagrant-ansible-slony] # tail first_build_single_node_setup.log
jan 25 10:16:28 pgnode1 systemd[1]: Started PostgreSQL 11 database server.
nohup: appending output to ‘nohup.out’
nohup: appending output to ‘nohup.out’
Connection to 127.0.0.1 closed.
 count 
-------
     1
(1 row)

Connection to 127.0.0.1 closed.
```

