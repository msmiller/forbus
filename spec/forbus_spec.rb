# frozen_string_literal: true

RSpec.describe Forbus do
  it "has a version number" do
    expect(Forbus::VERSION).not_to be nil
  end

  it "sets up Redis" do
    setup_redis
    expect( $redis ).not_to be nil
    key_count = $redis.keys("*")
    expect( key_count.length ).to eq( 0 )
  end
end
