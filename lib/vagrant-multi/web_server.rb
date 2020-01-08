require 'ipaddr'

module VagrantMulti
  class WebServer
    def self.all(count:, network:, port:, offset: 20)
      (0..(count - 1)).map do |index|
        new( index: index, network: network, offset: offset, port: port)
      end
    end

    attr_reader :name, :ip, :port

    def initialize(index:, network:, offset:, port:)
      @name = "web#{index}"
      @ip = network | IPAddr.new("0.0.0.#{offset + index}")
      @port = port
    end

    def url
      "http://#{name}:#{port}"
    end
  end
end
