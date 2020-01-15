# frozen_string_literal: true

require_relative 'helper'
require 'rest-client'

describe 'Multi-tier Web Application', type: :acceptance do
  subject(:response) { RestClient.get('http://192.168.42.2') }

  it 'has status success' do
    expect(response.code).to eq(200)
  end

  it 'has the page title' do
    expect(response.body).to include('Journal')
  end

  context 'multiple requests' do
    subject(:response_bodies) { 3.times.map { RestClient.get('http://192.168.42.2').body }}

    it 'contains a request served by each web server' do
      response_bodies.delete_if { |body| body.include?('web0') }
      response_bodies.delete_if { |body| body.include?('web1') }
      response_bodies.delete_if { |body| body.include?('web2') }

      expect(response_bodies).to be_empty
    end
  end
end
