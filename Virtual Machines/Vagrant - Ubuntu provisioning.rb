  config.vm.provision "shell", inline: <<-SHELL
    apt-get update && apt-get upgrade -y
    apt-get install -y aptitude
    aptitude install -y netcat-openbsd tcpdump traceroute mtr
    cp /vagrant/.profile /home/vagrant
    cp /vagrant/.vimrc /home/vagrant
  SHELL