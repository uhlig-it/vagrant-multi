# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

desc "System test"
task :system do
  sh 'vagrant validate'
end

task :default => :spec
