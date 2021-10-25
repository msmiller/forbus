# frozen_string_literal: true

RSpec.describe 'Ecosystem' do

  before :each do
    setup_redis
    @fb = FORbus.new
  end

  it "saves federation site info" do
    @fb.set_site_hash( SITE_HASH )

    result = $redis.get( Forbus.site_key )
    expected_result = JSON.parse(result)

    expect( expected_result ).to eq( @fb.get_site_hash )
  end

  it "saves channel imprints" do
    @fb.set_channel_imprint_hash( CHANNEL_HASH )

    result = $redis.get( Forbus.channel_imprint_key(CHANNEL_ID) )
    expected_result = JSON.parse(result)

    expect( expected_result ).to eq( @fb.get_channel_imprint_hash(CHANNEL_ID) )
  end

  it "saves actor imprints" do
    @fb.set_actor_imprint_hash( ACTOR_HASH )

    result = $redis.get( Forbus.actor_imprint_key(ACTOR_ID) )
    expected_result = JSON.parse(result)
    
    expect( expected_result ).to eq( @fb.get_actor_imprint_hash(ACTOR_ID) )
  end

  it "saves channel markers" do

    @fb.set_marker( 123, 456 )
    @fb.set_marker( 246, 135 )

    expect( @fb.get_marker(123) ).to eq(456)
    expect( @fb.get_marker(246) ).to eq(135)

    all_markers = @fb.get_markers_all
    expect( all_markers.length ).to eq( 2 )
    expect( all_markers[123] ).to eq( 456 )
    expect( all_markers[246] ).to eq( 135 )
  end


end
