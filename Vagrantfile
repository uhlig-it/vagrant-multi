$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require 'vagrant-multi/web_server'
require 'erb'

NETWORK = IPAddr.new('192.168.42.0').mask(24)
ENTRY_POINT = NETWORK | IPAddr.new('0.0.0.2')
WEB_SERVERS = VagrantMulti::WebServer.all(count: 3, network: NETWORK, offset: 20)
DB_HOST = NETWORK | IPAddr.new('0.0.0.3')
DB_NAME = 'journaldb'
DB_USER = 'journal-web'
DB_PASSWORD = 'UmpBrgnyOCUOAq9B'
DB_URL = "postgres://#{DB_USER}:#{DB_PASSWORD}@#{DB_HOST}/#{DB_NAME}"

def generate_haproxy_config(b = binding)
  ERB.new(File.read(File.join(__dir__, 'templates', 'haproxy.cfg.erb')), 0, "%<>").result(b)
end

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.provision 'shell', inline: 'ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime'

  config.vm.define 'db' do |cfg|
    cfg.vm.hostname = 'db'
    cfg.vm.network 'private_network', ip: DB_HOST.to_s
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

  WEB_SERVERS.each do |server|
    config.vm.define server.name do |cfg|
      cfg.vm.hostname = server.name
      cfg.vm.network 'private_network', ip: server.ip.to_s
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
    cfg.vm.network 'private_network', ip: ENTRY_POINT.to_s
    cfg.vm.provision 'shell', inline: <<~SCRIPT
      export DEBIAN_FRONTEND=noninteractive
      apt-get --yes install curl haproxy
      echo "#{generate_haproxy_config}" > /etc/haproxy/haproxy.cfg
      service haproxy reload
    SCRIPT
    cfg.vm.post_up_message = "The load balancer is available at http://#{ENTRY_POINT}"
  end
end
