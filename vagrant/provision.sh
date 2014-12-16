#!/bin/bash -x

#Update the OS
apt-get update 

#Install Git pip and other dependencies
apt-get install git software-properties-common devscripts python python-dev python-pip cdbs debhelper dpkg-dev reprepro -y

#install ansible dependencies 
pip install paramiko PyYAML jinja2 httplib2

#Create the ansible folders and group vars
mkdir -p /etc/ansible

#install pywinrm module 
pip install http://github.com/diyan/pywinrm/archive/master.zip

#After domain install may need kerberos
apt-get install libkrb5-dev
pip install kerberos

#User-config
su -c "source /vagrant/vagrant/user-config.sh" vagrant
