# frozen_string_literal: true

require "forbus"
require "redis"
require "amazing_print"
require "time"

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

SITE_HASH = { name: "Site One", site_id: 1, site_url: 'http://localhost:3000' }
SITE_HASH_2 = { name: "Site Two", site_id: 2, site_url: 'http://127.0.0.1' }
CHANNEL_ID = 123
CHANNEL_HASH = { name: "Channel One", channel_id: CHANNEL_ID, slug: 'channel_one' }
ACTOR_ID = 456
ACTOR_HASH = { name: "John Smith", actor_id: ACTOR_ID, slug: 'johnsmith', klass: 'User' }
COMMAND_HASH = { command: 'print', message: 'Hello World from FORBus !'}
