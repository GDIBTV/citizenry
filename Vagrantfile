# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "petecheslock/ubuntu-trusty-chef"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3000, host: 8000

  # Bump up the memory
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  config.vm.provision "chef_solo" do |chef|
  	chef.add_recipe "core"
  	chef.add_recipe "ruby"
  end

end
