Vagrant.configure('2') do |config|
  config.vm.box = 'debian/stretch64'
  config.vm.provision 'shell', inline: 'ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime'

  config.vm.define 'db' do |cfg|
    cfg.vm.hostname = 'db'
    cfg.vm.network 'private_network', ip: '192.168.42.30'
    cfg.vm.provision 'shell', inline: <<~SCRIPT
      apt-get -y install postgresql-9.6 postgresql-client-9.6
      su postgres -c 'echo vagrant | createuser vagrant --password'
      su postgres -c 'createdb -O vagrant journal'
      echo "listen_addresses=\'*\'" >> /etc/postgresql/9.6/main/postgresql.conf
      echo "host all all 192.168.42.0/24 trust" >> /etc/postgresql/9.6/main/pg_hba.conf
      service postgresql restart
    SCRIPT
  end

  (0..1).each do |index|
    config.vm.define "web#{index}" do |cfg|
      cfg.vm.hostname = "web#{index}"
      cfg.vm.network 'private_network', ip: "192.168.42.#{20 + index}"
      cfg.vm.provision 'shell', privileged: false, inline: <<~SCRIPT
        # Install Ruby
        sudo apt-get install -y ruby ruby-dev build-essential libpq-dev git
        sudo sh -c 'echo "gem: --no-document" > /etc/gemrc'
        sudo gem install bundler

        # Deploy the app
        git clone https://github.com/uhlig-it/journal.git
        cd journal
        bundle install --without development
        DB=postgres://vagrant:vagrant@192.168.42.30/journal rake db:migrate

        # Register the app with systemd
        sudo cp /vagrant/etc/journal.service /etc/systemd/system/
        sudo systemctl enable journal
        sudo systemctl start journal
      SCRIPT
    end
  end

  config.vm.define 'lb' do |cfg|
    cfg.vm.hostname = 'lb'
    cfg.vm.network 'private_network', ip: '192.168.42.2'
    cfg.vm.provision 'shell', inline: <<~SCRIPT
      apt-get -y install curl haproxy
      cp /vagrant/etc/haproxy.cfg /etc/haproxy/haproxy.cfg
      service haproxy reload
    SCRIPT
  end
end
