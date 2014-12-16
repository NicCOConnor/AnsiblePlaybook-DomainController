####**Ansible-Playbook: Server 2008 R2 Domain Controller**
The goal of this playbook is to automatically provision a Windows 2008 R2 domain controller with any number of member domain controllers. 
####**Vagrant Pre-reqs**
Vagrant 1.6.5+ https://www.vagrantup.com/

VirtualBox 4.3.12+ https://www.virtualbox.org/

I found it much easier to work in this environment by using the vagrant sahara plugin, this plugin allows you to create a VirtualBox snapshot  before applying any playbooks. Allowing you to repeat a playbook run much faster.

```vagrant plugin install sahara```

**Docs:** https://github.com/jedi4ever/sahara

####**Configuring the Vagrant Environment.** 
This Playbook comes equiped with a vagrant environment that needs to be configured before running. The First thing you will need to do is find a Windows 2008 R2 Vagrant Box and then configure that box to work with ansible. 

I've found the packer application made by hashicorp (The same company that created vagrant) and this github repo to be helpful https://github.com/joefitzgerald/packer-windows however it takes a huge amount of time when updating windows. 

The best way I've found is to just create a box from ISO and update from windows updates. To create a vagrant box follow the documentation on the vagrant website https://docs.vagrantup.com/v2/boxes/base.html 

Once you have your vagrant box built. You will then need to configure the vagrant box to work with ansible and winrm. The vagrant folder contains two scripts that can do this for you. I've avoided running these scripts automatically because I've found the "upgrade\_to\_ps3.ps1" script will not run unless Server 2008 R2 is at a certain patch level (When I Identify this patch level I will update this README). Additionally the winrmsetup.ps1 script will not run without powershell 3.0+ installed. 

To configure a box to run with Ansible copy "*vagrant\\upgrade\_to_ps3.ps1*" and "*vagrant\\winrmsetup.ps1*" and run them inside the vm. (**_Note_**: upgrade_to_ps3.ps1 requires internet access)

The vagrant environment provisions the following:
- 2x  Windows 2008 R2 machines 
- 1x Ansible machine based off of ubuntu 12.04

#####**Modify the Vagrantfile**
for the PDC and MDC box change this line to your specific vagrant box

    win.vm.box = "server-2008-r2-21NOV14" #CHANGE ME

The linux machine, which will become the ansible server uses the hashicorp/precise image and is readily available on the internet. The ```vagrant up``` command will automatically download and install this vagrant box onto your computer. 

#####**Ansible Setup**
You need to make some changes in the playbook gourp_vars *Playbook/group_vars/all.yml* Most of these should be self explanitory if you are using the vagrant environment the username and password will be vagrant / vagrant for both the "ansible_ssh_\*" and "domain_\*"
```yaml
ansible_ssh_user: Administrator
ansible_ssh_pass: vagrant
ansible_ssh_port: 5986
ansible_connection: winrm
network: 192.168.33.0
domain_username: Administrator
domain_password: vagrant
domain: "testing.com"
netbios: "testing"
dns_server: 192.168.33.10 # Change to expected DC-01 IP(PDC role)
```

additionally you will need to update your hosts file. The script will automatically change the hostname using the win_hostname module that I wrote. it uses the name specified in the hosts file, you will need to change the hosts file to match your environment it is currently set for the vagrant environment. 
```ini
[pdc]
DC-01 ansible_ssh_host=192.168.33.10
[mdc]
DC-02 ansible_ssh_host=192.168.33.12
#DC-East ansible_ssh_host=192.168.33.13
#DC-West ansible_ssh_host=192.168.33.14
#etc...
```

#####**Running the Ansible Playbook**#####
If you installed the sahara plugin for vagrant take a snapshot of your environment

```vagrant sandbox on```

follow these steps to run the Ansible Playbook
```
PS > vagrant provision ansible
PS > vagrant ssh ansible
#: cd ~/Playbook
ansible-playbook -i hosts site.yml -vvv
```

Once your done and you want to make changes, or run your playbook again rollback your vagrant environment 
```vagrant sandbox rollback```
