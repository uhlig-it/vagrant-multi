# frozen_string_literal: true

require 'rspec/core/rake_task'

namespace :spec do
  desc "System test"
  task :system do
    sh 'vagrant validate'
  end

  %w[unit acceptance].each do |type|
     desc "Run #{type} tests"
     RSpec::Core::RakeTask.new(type) do |t|
       t.pattern = "spec/#{type}/**/*_spec.rb"
     end
  end
end

task default: ['spec:unit', 'spec:system', 'spec:acceptance']
