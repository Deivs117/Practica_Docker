# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"

  # Cliente Ubuntu
  config.vm.define "clienteUbuntu" do |cliente|
    cliente.vm.hostname = "clienteUbuntu"
    cliente.vm.network "private_network", ip: "192.168.100.2"

    cliente.vm.provider "virtualbox" do |vb|
      vb.name   = "clienteUbuntu"
      vb.memory = "1024"
      vb.cpus   = 1
    end

    cliente.vm.synced_folder ".", "/home/vagrant/repo"

    cliente.vm.provision "shell", path: "scripts/provision-common.sh"
  end

  # Servidor Ubuntu
  config.vm.define "servidorUbuntu" do |servidor|
    servidor.vm.hostname = "servidorUbuntu"
    servidor.vm.network "private_network", ip: "192.168.100.3"

    servidor.vm.provider "virtualbox" do |vb|
      vb.name   = "servidorUbuntu"
      vb.memory = "1024"
      vb.cpus   = 1
    end

    servidor.vm.synced_folder ".", "/home/vagrant/repo"

    servidor.vm.provision "shell", path: "scripts/provision-common.sh"
    servidor.vm.provision "shell", path: "scripts/provision-server.sh"
  end
end
