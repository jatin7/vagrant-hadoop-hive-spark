#!/bin/bash
# https://docs.vagrantup.com/v2/provisioning/shell.html

source "/vagrant/scripts/common.sh"

function setupHosts {
	echo "modifying /etc/hosts file"
	echo "10.211.55.100 master1 master1.hadoop.network" >> /etc/nhosts
	echo "10.211.55.101 worker1 worker1.hadoop.network" >> /etc/nhosts
	echo "10.211.55.102 worker2 worker2.hadoop.network" >> /etc/nhosts
	echo "10.211.55.103 worker3 worker3.hadoop.network" >> /etc/nhosts
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts
	cp /etc/nhosts /etc/hosts
	rm -f /etc/nhosts
}

function setupSwap {
    # setup swapspace daemon to allow more memory usage.
    apt-get install -y swapspace
}


function installSSHPass {
	apt-get update
	apt-get install -y sshpass
}

function overwriteSSHCopyId {
	cp -f $RES_SSH_COPYID_MODIFIED /usr/bin/ssh-copy-id
}

function createSSHKey {
	echo "generating ssh key"
	ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	cp -f $RES_SSH_CONFIG ~/.ssh
}

function setupUtilities {
    # so the `locate` command works
    apt-get install -y mlocate
    updatedb
    apt-get install -y ant
    apt-get install -y unzip
    apt-get install -y python-minimal
    apt-get install -y curl apt-utils
    apt-get install -y telnet less
}

echo "setup ubuntu"

echo "setup hosts file"
setupHosts

echo "setup ssh"
installSSHPass
createSSHKey
overwriteSSHCopyId

echo "setup utilities"
setupUtilities

echo "setup swap daemon"
setupSwap

echo "ubuntu setup complete"
