#### **Ansible-Playbook: Server 2008 R2 Domain Controller**
The goal of this playbook is to automatically provision a Windows 2008 R2 domain controller with any number of member domain controllers. This playbook provides a vagrant environment as well as playbooks to run against vCenter.



**Note:**
If you intend to use this playbook outside the vagrant environment provided, it will not work without first installing ansible-modules-extras from source through my forked github repo https://github.com/NicCOConnor/ansible-modules-extras, see the vagrant/user-config.sh script for an idea on how to accomplish this.

#### **vCenter Pre-reqs**
- vCenter Server
- windows template with snapshot.

There are two helper playbooks create.yml and delete.yml that leverage the ```vsphere_guest``` module of Ansible. these playbooks also leverage the newly added ```snapshot_to_clone:``` parameter which allows us to rapidly clone templates as linked clones.

#### **Create the Windows Template VM**
##### **vCenter**
- Install Windows and Update to your desired patch level
- add any additional applications that you want in your template 
- Install VMWare Tools 
- Run ```vagrant\upgrade_to_p3s.ps1``` 
- Run ```vagrant\winrmsetup.ps1```
- Take Snapshot named "LinkClone"

##### **Vagrant \ VirtualBox**
- Install Windows and Update to your desired patch level
- add any additional applications that you want in your template 
- Install Virtualbox Guest Additions
- Run ```vagrant\upgrade_to_p3s.ps1``` 
- Run ```vagrant\winrmsetup.ps1```
- Import Box to vagrant  

#### **Vagrant Pre-reqs**
Vagrant 1.6.5+ https://www.vagrantup.com/

VirtualBox 4.3.12+ https://www.virtualbox.org/

I found it much easier to work in this environment by using the vagrant sahara plugin, this plugin allows you to create a VirtualBox snapshot  before applying any playbooks. Allowing you to repeat a playbook run much faster.

```vagrant plugin install sahara```

**Docs:** https://github.com/jedi4ever/sahara

#### **Configuring the Vagrant Environment.** 
This Playbook comes equiped with a vagrant environment that needs to be configured before running. The First thing you will need to do is find a Windows 2008 R2 Vagrant Box and then configure that box to work with ansible. 

I've found the packer application made by hashicorp (The same company that created vagrant) and this github repo to be helpful https://github.com/joefitzgerald/packer-windows however it takes a huge amount of time when updating windows. 

The best way I've found is to just create a box from ISO and update from windows updates. To create a vagrant box follow the documentation on the vagrant website https://docs.vagrantup.com/v2/boxes/base.html 

The vagrant environment provisions the following:
- 2x  Windows 2008 R2 machines 
- 1x Ansible machine based off of ubuntu 12.04

##### **Modify the Vagrantfile**
for the PDC and MDC box change this line to your specific vagrant box

    win.vm.box = "server-2008-r2-21NOV14" #CHANGE ME

The linux machine, which will become the ansible server uses the hashicorp/precise image and is readily available on the internet. The ```vagrant up``` command will automatically download and install this vagrant box onto your computer. 

##### **Ansible Setup**
You need to make some changes in the playbook gourp_vars *Playbook/group_vars/all/all.yml* Most of these should be self explanatory. 
```yaml
ansible_ssh_port: 5986
ansible_connection: winrm
network: 192.168.33.0
domain: "testing.com"
netbios: "testing"
vCenter_datastore: nfs_datastore
vCenter_Hostname: vcenter.testing.com
vCenter_Cluster: main_cluster
```
You should also create a separate creds.yml file in *Playbook/group_vars/all/creds.yml* utilizing ansible-vault to encrypt your credentials. This file is not included in this repo. If you are using the vagrant environment the username and password will be vagrant / vagrant for both the "ansible_ssh_\*" and "domain_\*" 
```yaml
ansible_ssh_user: Administrator
ansible_ssh_pass: vagrant
domain_username: Administrator
domain_password: vagrant
vCenter_Username: Administrator
vCenter_Pass: <Your-vCenter-Pass>
```
This playbook comes equipped with two hosts files, one for ESXi and another for vagrant. The key difference being the esxi Host file does not specify an IP address the create.yml playbook will automatically update the hosts file based on the vsphere_guest gather facts method. The Playbook will automatically change the hostname of the VMs using the win_hostname module that I wrote. it uses the name specified in the hosts file, you will need to choose the hosts file to match your environment, you can rename the provided hosts file or use them in place with the ansible-playbook -i option 
```ini
[pdc]
DC-01 ansible_ssh_host=192.168.33.10
[mdc]
DC-02 ansible_ssh_host=192.168.33.12
#DC-East ansible_ssh_host=192.168.33.13
#DC-West ansible_ssh_host=192.168.33.14
#etc...
```

##### **Running the Ansible Playbook**#####

###### **vCenter / ESXi**
```
PS > vagrant up ansible
PS > vagrant provision ansible
PS > vagrant ssh ansible
#: cd ~/Playbook
#: ansible-playbook -i esxi-hosts create.yml
#: ansible-playbook -i hosts site.yml 
```

**__note__** the hosts file is different for create.yml and site.yml

###### **Vagrant**
If you installed the sahara plugin for vagrant take a snapshot of your environment

```vagrant sandbox on```

follow these steps to run the Ansible Playbook
```
PS > vagrant up
PS > vagrant provision ansible
PS > vagrant ssh ansible
#: cd ~/Playbook
ansible-playbook -i hosts site.yml -vvv
```

Once your done and you want to make changes, or run your playbook again rollback your vagrant environment 
```vagrant sandbox rollback```
