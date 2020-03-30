require "bundler/setup"
$LOAD_PATH << Pathname(Gem.bin_path('steep', 'steep')).join('../../vendor/ruby-signature/lib')
Bundler.require

require "steep"
require "steep/cli"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
