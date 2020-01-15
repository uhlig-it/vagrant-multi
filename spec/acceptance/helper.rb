# frozen_string_literal: true

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # config.disable_monkey_patching!
  config.warnings = false

  Kernel.srand config.seed
end
