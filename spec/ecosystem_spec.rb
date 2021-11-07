# frozen_string_literal: true

# This tests set up and anything sent across the ecosystem list

RSpec.describe 'Ecosystem' do

  before :each do
    setup_redis
    @fb = FORbus.new
  end

  context "sites" do

    it "saves federation site info" do
      @fb.set_site_hash( SITE_HASH )

      result = $redis.get( Forbus.site_key )
      expected_result = JSON.parse(result)

      expect( expected_result ).to eq( @fb.get_site_hash )
    end

  end

  context "imprints" do

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

  end

  context "channel markers" do

    it "saves channel markers" do
      @fb.set_marker( 123, 456 )
      @fb.set_marker( 246, 135 )

      expect( @fb.get_marker(123) ).to eq(456)
      expect( @fb.get_marker(246) ).to eq(135)

      all_markers = @fb.get_markers_all
      expect( all_markers.length ).to eq( 3 ) # 2 channels + lastupdate
      expect( all_markers[123] ).to eq( 456 )
      expect( all_markers[246] ).to eq( 135 )

      lastupdate = @fb.get_marker_lastupdate
      expect( Date.parse(lastupdate).to_s ).to eq( Date.today.to_s )
    end

  end

  context "rpc" do

    it "saves rpc response" do
      @response_hash =  { a: 1, b: 2, c: { x: 111, y: 222 }}
      @response_id = "xyzzy"
      @fb.push_rpc_response( @response_id, @response_hash)

      result = $redis.get( Forbus.rpc_key(@response_id) )
      expect( result ).to eq( @response_hash.to_json )
    end

  end

  context "utils" do

    it "generates random user-pass" do
      userpass = Forbus.create_random_user_pass

      expect( userpass.length ).to eq( 2 )
      expect( userpass[:username].length ).to eq( 20 )
      expect( userpass[:password].length ).to eq( 20 )
    end

  end

end
