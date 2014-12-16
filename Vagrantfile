# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Windows Box PDC
  config.vm.define "pdc" do |win|
    win.vm.box = "server-2008-r2-21NOV14"
    win.vm.guest = "windows"
    win.vm.communicator = "winrm"
    win.vm.network :forwarded_port, guest: 80, host: 4321
    win.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct:true
    win.vm.network :forwarded_port, guest: 3389, host: 13389, id: "rdp", auto_correct:true
    win.vm.network "private_network", ip: "192.168.33.10"
  end
  # Windows Box MDC
  config.vm.define "mdc" do |win|
    win.vm.box = "server-2008-r2-21NOV14"
    win.vm.guest = "windows"
    win.vm.communicator = "winrm"
    win.vm.network :forwarded_port, guest: 80, host: 4322
    win.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct:true
    win.vm.network :forwarded_port, guest: 3389, host: 13389, id: "rdp", auto_correct:true
    win.vm.network "private_network", ip: "192.168.33.12"
  end
  #Ansible Hosts
  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "hashicorp/precise64"
    ansible.vm.network "private_network", ip: "192.168.33.11"
    ansible.vm.provision "shell", path: "vagrant/provision.sh"
      
  end
  #Configure the provider
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end
