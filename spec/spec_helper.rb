# frozen_string_literal: true

require "forbus"
require "redis"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def setup_redis
  $redis = Redis.new
  begin
    $redis.ping
  rescue
    raise StandardError, 'redis-server needs to be running'
  end
  $redis.flushall
  $redis.flushdb
end