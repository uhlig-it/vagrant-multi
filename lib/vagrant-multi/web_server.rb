require 'ipaddr'

module VagrantMulti
  class WebServer
    def self.all(count:, network:, offset: 20)
      (0..(count - 1)).map do |index|
        new( index: index, network: network, offset: offset)
      end
    end

    attr_reader :name, :ip

    def initialize(index:, network:, offset:)
      @name = "web#{index}"
      @ip = network | IPAddr.new("0.0.0.#{offset + index}")
    end
  end
end
