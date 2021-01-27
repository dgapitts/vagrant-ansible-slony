cd /tmp
#pg_dump -s -d pgbench -U vagrant | psql -d pgbenchslave -U vagrant
sudo su -c "createuser vagrant"  -s /bin/sh postgres
sudo su -c "createdb -O vagrant pgbenchslave"  -s /bin/sh postgres
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@192.168.60.4 pg_dump -s -d pgbench | psql -d pgbenchslave 
sudo su -c "bash /vagrant/setup_slonyrep_dbuser.sh"  -s /bin/sh postgres
sudo su -c "createuser slonyrep -P changeme -g pgbenchslave" -s /bin/sh postgres
