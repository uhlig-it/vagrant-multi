# frozen_string_literal: true

# $LOAD_PATH.unshift
warn File.expand_path('../lib', __dir__)

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
