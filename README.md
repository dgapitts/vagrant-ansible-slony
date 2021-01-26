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
[~/projects/vagrant-ansible-slony] # head first_build_single_node_setup.log
[~/projects/vagrant-ansible-slony] # uptime;vagrant destroy;vagrant up;vagrant ssh -c "sudo bash /vagrant/base_setup_single_node.sh";vagrant ssh -c "psql -d pgbenchslave -c 'select count(*) from pgbench_branches;'";uptime
 11:44:08 up 31 days,  1:36,  4 users,  load average: 0,29, 0,42, 0,36
    db1: Are you sure you want to destroy the 'db1' VM? [y/N] y
==> db1: Forcing shutdown of VM...
==> db1: Destroying VM and associated drives...
Bringing machine 'db1' up with 'virtualbox' provider...
==> db1: Importing base box 'geerlingguy/centos7'...
==> db1: Matching MAC address for NAT networking...
==> db1: Checking if box 'geerlingguy/centos7' is up to date...
==> db1: Setting the name of the VM: vagrant-ansible-slony_db1_1611657870694_68609
[~/projects/vagrant-ansible-slony] # tail first_build_single_node_setup.log
nohup: appending output to ‘nohup.out’
nohup: appending output to ‘nohup.out’
Connection to 127.0.0.1 closed.
 count 
-------
     1
(1 row)

Connection to 127.0.0.1 closed.
 11:46:30 up 31 days,  1:39,  4 users,  load average: 0,79, 0,61, 0,44
```
and double checking by adding a test row to pgbench_branches
```
[~/projects/vagrant-ansible-slony] # vagrant ssh -c "psql -d pgbench -c 'insert into pgbench_branches values (2,100);commit;select pg_sleep(1);';psql -d pgbenchslave -c 'select * from pgbench_branches;'"
INSERT 0 1
 bid | bbalance | filler 
-----+----------+--------
   1 |        0 | 
   2 |      100 | 
(2 rows)
Connection to 127.0.0.1 closed.
[~/projects/vagrant-ansible-slony] # 
```
