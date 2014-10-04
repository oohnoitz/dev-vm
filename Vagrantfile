# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dev"
  config.vm.box_url = "https://googledrive.com/host/0B83ZToJ3fGtDVC1DeVVzc3lkc0U/debian-7.6.0-amd64_virtualbox.box"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "shell", path: "build.sh"
end
