# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # https://vagrantcloud.com/ubuntu
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", type: "dhcp"

  # Forward ports
  config.vm.network "forwarded_port", guest: 8080, host: 8080 # web server
  config.vm.network "forwarded_port", guest: 5432, host: 5432 # Postgres

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  # If true, then any SSH connections made will enable agent forwarding.
  config.ssh.forward_agent = true

  # Share additional folders to the guest VM.
  config.vm.synced_folder "data", "/data"

  # Bash provision script
  config.vm.provision "shell", path: "Scripts/PuppetInstallation.sh"
end
