cd /tmp
echo 'step 1'
sudo su -c "createuser vagrant" -s /bin/sh postgres
echo 'step 2'
sudo su -c "createdb -O vagrant pgbench"  -s /bin/sh postgres
echo 'step 3'
/usr/pgsql-11/bin/pgbench -i -s 1 -d pgbench
bash /vagrant/add-pgbench_history-candidate-PK-for-slony.sh
sudo su -c "bash /vagrant/setup_slonyrep_dbuser.sh"  -s /bin/sh postgres
sudo su -c "createuser slonyrep -P changeme -g pgbench" -s /bin/sh postgres

