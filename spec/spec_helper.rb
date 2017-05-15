require "bundler/setup"
require "tachyon"
require "active_record"
require "active_support"
require "active_support/core_ext"
require "benchmark"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/schema.rb'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    $benchmarks = {}
  end

  config.after(:suite) do
    puts "\n\nBenchmark Results:"
    $benchmarks.each do |test_name, result|
      puts test_name.ljust(27) + ": " + result.to_s
    end
  end
end
