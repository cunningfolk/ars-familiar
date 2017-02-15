require "bundler/setup"
require "ars/familiar"

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Aruba.configure do |config|
  config.working_directory = 'lib/portable_models'
end
