# frozen_string_literal: true

require_relative 'helper'
require 'vagrant-multi/web_server'

module VagrantMulti
  describe WebServer do
    let(:network) { IPAddr.new('192.168.11.0').mask(24) }

    subject(:all) do
      described_class.all(count: 42, network: network, offset: 11, port: 1234)
    end

    it 'lists all web servers' do
      expect(all).to be
    end

    it 'has the expected count of web servers' do
      expect(all.size).to eq(42)
    end

    it 'starts the ip address at the given offset' do
      expect(all.first.ip).to eq(IPAddr.new('192.168.11.11'))
    end

    it 'assigns the expected names' do
      expect(all.first.name).to eq('web0')
      expect(all[41].name).to eq('web41')
    end

    it 'assignes the ip addresses in order' do
      expect(all[1].ip).to eq(IPAddr.new('192.168.11.12'))
      # ...
      expect(all[41].ip).to eq(IPAddr.new('192.168.11.52'))
    end

    it 'has the desired port' do
      expect(all[1].port).to eq(1234)
    end
  end
end
