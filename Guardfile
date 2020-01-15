guard :rspec, cmd: 'bundle exec rspec' do
   watch(%r{^spec/unit/.+_spec\.rb$})
   watch(%r{^spec/acceptance/.+_spec\.rb$})
   watch(%r{^lib/(.+/.+)\.rb$}) do |m|
     "spec/#{m[1]}_spec.rb"
   end
 end
