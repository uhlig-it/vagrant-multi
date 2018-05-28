ENTRY_POINT = '192.168.42.2'
WEB_INSTANCE_COUNT = 2
DBMS_ADDRESS = '192.168.42.30'
DB_NAME = 'journaldb'
DB_USER = 'journal-web'
DB_PASSWORD = 'UmpBrgnyOCUOAq9B'
DB_URL = "postgres://#{DB_USER}:#{DB_PASSWORD}@#{DBMS_ADDRESS}/#{DB_NAME}"

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/stretch64'
  config.vm.provision 'shell', inline: 'ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime'

  config.vm.define 'db' do |cfg|
    cfg.vm.hostname = 'db'
    cfg.vm.network 'private_network', ip: DBMS_ADDRESS
    cfg.vm.provision 'shell',
      path: 'install-database',
      privileged: true,
      env: {
        DB_NAME: DB_NAME,
        DB_PASSWORD: DB_PASSWORD,
        DB_USER: DB_USER,
      }
    cfg.vm.post_up_message = "The database is available at #{DB_URL}"
  end

  (0..(WEB_INSTANCE_COUNT - 1)).each do |index|
    config.vm.define "web#{index}" do |cfg|
      cfg.vm.hostname = "web#{index}"
      cfg.vm.network 'private_network', ip: "192.168.42.#{20 + index}"
      cfg.vm.provision 'shell',
        path: 'deploy-app',
        privileged: false,
        env: {
          DB_URL: DB_URL,
        }
      cfg.vm.post_up_message = "Application server #{cfg.vm.hostname} is available."
    end
  end

  config.vm.define 'lb' do |cfg|
    cfg.vm.hostname = 'lb'
    cfg.vm.network 'private_network', ip: ENTRY_POINT
    cfg.vm.provision 'shell', inline: <<~SCRIPT
      apt-get -y install curl haproxy
      cp /vagrant/etc/haproxy.cfg /etc/haproxy/haproxy.cfg
      service haproxy reload
    SCRIPT
    cfg.vm.post_up_message = "The load balancer is available at http://#{ENTRY_POINT}"
  end
end
