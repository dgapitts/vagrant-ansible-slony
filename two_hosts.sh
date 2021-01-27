vagrant ssh db1 -c "sudo bash /vagrant/two_hosts_base_install.sh"
vagrant ssh db2 -c "sudo bash /vagrant/two_hosts_base_install.sh"
echo "two_hosts_setup_and_preload_pgbench.sh"
vagrant ssh db1 -c "sudo bash /vagrant/two_hosts_setup_and_preload_pgbench.sh"
echo "two_hosts_setup_schemaonly_pgbenchslave.sh"
vagrant ssh db2 -c "sudo bash /vagrant/two_hosts_setup_schemaonly_pgbenchslave.sh"

