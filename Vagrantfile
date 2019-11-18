require 'erb'
require 'ipaddr'

WEB_INSTANCE_COUNT = 3
NETWORK = IPAddr.new('192.168.42.0').mask(24)

ENTRY_POINT = NETWORK | IPAddr.new('0.0.0.2')
DB_HOST = NETWORK | IPAddr.new('0.0.0.3')
DB_NAME = 'journaldb'
DB_USER = 'journal-web'
DB_PASSWORD = 'UmpBrgnyOCUOAq9B'
DB_URL = "postgres://#{DB_USER}:#{DB_PASSWORD}@#{DB_HOST}/#{DB_NAME}"

def ip(index)
  NETWORK | IPAddr.new("0.0.0.#{index}")
end

def web_server_ip(index)
  ip(20 + index)
end

def web_server_name(index)
  "web#{index}"
end

def generate_haproxy_config(b = binding)
  web_servers = (0..(WEB_INSTANCE_COUNT - 1)).map do |index|
    [web_server_name(index), web_server_ip(index)]
  end

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

  (0..(WEB_INSTANCE_COUNT - 1)).each do |index|
    config.vm.define web_server_name(index) do |cfg|
      cfg.vm.hostname = web_server_name(index)
      cfg.vm.network 'private_network', ip: web_server_ip(index).to_s
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
