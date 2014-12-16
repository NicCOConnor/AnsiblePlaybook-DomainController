#!/bin/bash -x

echo "Creating Source Directory and configuring ansible"
mkdir ~/source/
cd ~/source/

#Cloning from my own github forks since win_hostname has not been merged into ansible yet
git clone https://github.com/NicCOConnor/ansible.git -b devel
git clone https://github.com/NicCOConnor/ansible-modules-extras.git -b win_hostname
git clone https://github.com/ansible/ansible-modules-core.git

#Set environment variable so my fork Repos work
export ANSIBLE_LIBRARY=~/source/ansible-modules-core:~/source/ansible-modules-extras

#Also setting ANSIBLE_LIBRARY in profile so I can login and troubleshoot
echo "export ANSIBLE_LIBRARY=~/source/ansible-modules-core:~/source/ansible-modules-extras" >> ~/.profile
cd ~/source/ansible

#Ansible now uses submodules so we will recursivly update them. 
#This is not required since I am specifying my own ANSIBLE_LIBRARY
#But whatever, I'm keeping it 
git submodule update --init --recursive

#Install ansible
sudo make install 

#Remove current Playbook 
rm -rf ~/Playbook
#Copy the test playbook
cp -rf /vagrant/Playbook/ ~/
chmod -x ~/Playbook/hosts
#Run the ansible playbook 
cd ~/Playbook/

#Uncomment if you want to run the playbook right away.
#I prefer to sandbox the envionrment with vagrant sahara
#since the vagrant environment takes a bit of time to come up.  

#ansible-playbook -i hosts site.yml -vvv
