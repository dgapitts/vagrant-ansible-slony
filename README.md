## Summary

Continuing on my initial exploration of setting up slony on a single node (https://github.com/dgapitts/vagrant-pg96-slony), this new project aim to:
* replace as much as possible of the configuration to ansible (starting by installing postgres via ansible as per https://github.com/dgapitts/vagrant-ansible-for-devops)
* move on from a single host (playing master and slave) to 2 and 3 host configurations (building on top of https://github.com/dgapitts/vagrant-ansible-for-devops-3nodes)
* investigate other slony replication features e.g.monitoring and failover

So far I have:
*  complete initial single-host setup with ansible to install postgres 

Fortunately, this should be easy to extend to a two-host config i.e. my next step


## Highlight from an initial single-node setup with ansible to install postgres 

I have attached the full log (build_logs/first_build_single_node_setup.log) for this initial run setup

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
and double-checking by adding a test row to pgbench_branches
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


## second build_two node setup

### v0.01

see (build_logs/second_build_two_node_setup_v0.01.log) for full log details

I've started the next phase i.e. moving to a 

```
uptime;yes|vagrant destroy;vagrant up;./two_hosts.sh;vagrant ssh db2 -c "psql -d pgbenchslave -c '\d'";uptime
```

the key point above being
1. the vagrant up uses ansible provisioning of postgres
22. the two_hosts.sh file does further software installs and setups postgres roles, databases and initial dataload
```
[~/projects/vagrant-ansible-slony] # cat two_hosts.sh 
vagrant ssh db1 -c "sudo bash /vagrant/two_hosts_base_install.sh"
vagrant ssh db2 -c "sudo bash /vagrant/two_hosts_base_install.sh"
echo "two_hosts_setup_and_preload_pgbench.sh"
vagrant ssh db1 -c "sudo bash /vagrant/two_hosts_setup_and_preload_pgbench.sh"
echo "two_hosts_setup_schemaonly_pgbenchslave.sh"
vagrant ssh db2 -c "sudo bash /vagrant/two_hosts_setup_schemaonly_pgbenchslave.sh"
```
3. finally i.e. third I run a check on the slave db (I should propably rename this pgbenchA and pgbenchB as at some stage I want to test out failover)
```
psql -d pgbenchslave -c '\d'
...
--------+------------------------+----------+---------
 public | pgbench_accounts       | table    | vagrant
 public | pgbench_branches       | table    | vagrant
 public | pgbench_history        | table    | vagrant
 public | pgbench_history_id_seq | sequence | vagrant
 public | pgbench_tellers        | table    | vagrant
```

Running the above, it basically works, although there are some apparently spurious ERRORs i.e. the creation of postgres roles and databases (details below) do actually work, so I'm puzzled by these apparent false-positive errors

```
[~/projects/vagrant-ansible-slony] # uptime;yes|vagrant destroy;vagrant up;./two_hosts.sh;vagrant ssh db2 -c "psql -d pgbenchslave -c '\d'";uptime
 13:28:08 up 32 days,  3:20,  5 users,  load average: 0,34, 0,22, 0,29
Vagrant is attempting to interface with the UI in a way that requires
a TTY. Most actions in Vagrant that require a TTY have configuration
switches to disable this requirement. Please do that or run Vagrant
with TTY.
Bringing machine 'db1' up with 'virtualbox' provider...
Bringing machine 'db2' up with 'virtualbox' provider...
==> db1: Checking if box 'geerlingguy/centos7' is up to date...
==> db1: Machine already provisioned. Run `vagrant provision` or use the `--provision`
[~/projects/vagrant-ansible-slony] # tail second_build_single_node_setup_v0.01.log
--------+------------------------+----------+---------
 public | pgbench_accounts       | table    | vagrant
 public | pgbench_branches       | table    | vagrant
 public | pgbench_history        | table    | vagrant
 public | pgbench_history_id_seq | sequence | vagrant
 public | pgbench_tellers        | table    | vagrant
(5 rows)

Connection to 127.0.0.1 closed.
 13:28:30 up 32 days,  3:21,  5 users,  load average: 0,57, 0,29, 0,31
[~/projects/vagrant-ansible-slony] # grep ERROR second_build_single_node_setup_v0.01.log
createuser: creation of new role failed: ERROR:  role "vagrant" already exists
createdb: database creation failed: ERROR:  database "pgbench" already exists
createuser: creation of new role failed: ERROR:  role "slonyrep" already exists
createuser: creation of new role failed: ERROR:  role "vagrant" already exists
createdb: database creation failed: ERROR:  database "pgbenchslave" already exists
createuser: creation of new role failed: ERROR:  role "slonyrep" already exists
```

