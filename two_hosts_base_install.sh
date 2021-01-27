echo "ADD EXTRA ALIAS VIA .bashrc"
cat /vagrant/bashrc.append.txt >> /home/vagrant/.bash_profile
cat /vagrant/bashrc.append.txt >> /root/.bashrc
echo "alias pg='sudo su - postgres'" >> /home/vagrant/.bashrc
echo "alias bench='sudo su - bench1'" >> /home/vagrant/.bashrc
#echo "GENERAL YUM UPDATE"
#yum -y update
yum  -y install unzip curl wget

yum install -y perl
yum install -y slony1-11

#yum -y install python-psycopg2
cat /vagrant/bashrc.append.txt >> /tmp/bashrc.append.txt
su -c "cat /tmp/bashrc.append.txt >> ~/.bashrc" -s /bin/sh postgres
su -c "cat /tmp/bashrc.append.txt >> ~/.bash_profile" -s /bin/sh postgres
echo 'export PATH="$PATH:/usr/pgsql-11/bin"' >> /var/lib/pgsql/.bash_profile

yum -y install sysstat
systemctl start sysstat 
systemctl enable sysstat
sed -i 's#*/10#*/1#g' /etc/cron.d/sysstat
#/vagrant/quick-start-setup-pg-ora-demo-scripts.sh

# https://www.slony.info/documentation/security.html
su -c "echo 'localhost:5432:pgbench:slonyrep:changeme' >> ~/.pgpass" -s /bin/sh postgres
su -c "echo 'localhost:5432:pgbenchslave:slonyrep:changeme' >> ~/.pgpass" -s /bin/sh postgres
su -c "echo 'localhost:5432:pgbench:postgres:changeme' >> ~/.pgpass" -s /bin/sh postgres
su -c "echo 'localhost:5432:pgbenchslave:postgres:changeme' >> ~/.pgpass" -s /bin/sh postgres
su -c "chmod 600 ~/.pgpass" -s /bin/sh postgres


# initial cron
crontab /vagrant/root_cronjob_monitoring_sysstat_plus_custom_pgmon.txt


# default pg_hba.conf doesn't allow md5 i.e. password based authentication 
cp /vagrant/pg_hba.conf /tmp/pg_hba.conf
su -c "cp -p /var/lib/pgsql/11/data/pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf.`date '+%Y%m%d-%H%M'`.bak" -s /bin/sh postgres
su -c "cat /tmp/pg_hba.conf > /var/lib/pgsql/11/data/pg_hba.conf" -s /bin/sh postgres
# set listen_addresses='*' in postgresql.conf
cp /vagrant/postgresql.conf /tmp/postgresql.conf
su -c "cp -p /var/lib/pgsql/11/data/postgresql.conf /var/lib/pgsql/11/data/postgresql.conf.`date '+%Y%m%d-%H%M'`.bak" -s /bin/sh postgres
su -c "cat /tmp/postgresql.conf > /var/lib/pgsql/11/data/postgresql.conf" -s /bin/sh postgres
systemctl stop postgresql-11
systemctl start postgresql-11
systemctl status postgresql-11

# and finally initialize slony master and slave, plus start the master and slave processes
# cp /vagrant/setup_slony_master_and_slave.sh /tmp/setup_slony_master_and_slave.sh
# su -c "bash /tmp/setup_slony_master_and_slave.sh" -s /bin/sh postgres


