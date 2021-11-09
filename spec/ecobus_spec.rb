# frozen_string_literal: true

# This tests set up and anything sent across the ecosystem list

RSpec.describe 'Ecobus' do

  before :each do
    setup_redis
    @fb = FORbus.new
  end

  context "send / receive" do

    it "can post to list and read" do
      @subscriber_token = Forbus.create_random_token
      expect( @subscriber_token.length ).to eq( 20 )

      buslen = @fb.ecobus_length(@subscriber_token)
      expect( buslen ).to eq( 0 )
      @fb.push_ecobus_command(@subscriber_token, COMMAND_HASH)
      buslen = @fb.ecobus_length(@subscriber_token)
      expect( buslen ).to eq( 1 )
    end

    it "can read from list" do
      @subscriber_token = Forbus.create_random_token
      @fb.push_ecobus_command(@subscriber_token, COMMAND_HASH)
      buslen = @fb.ecobus_length(@subscriber_token)
      expect( buslen ).to eq( 1 )

      result = @fb.pull_ecobus_command(@subscriber_token)
      buslen = @fb.ecobus_length(@subscriber_token)
      expect( buslen ).to eq( 0 )
      expect( result.length ).to eq( 2 )
      expect( result['command'] ).to eq( COMMAND_HASH['command'] )
      expect( result['message'] ).to eq( COMMAND_HASH['message'] )
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

    it "can clear a bus" do
      @subscriber_token = Forbus.create_random_token
      @fb.push_ecobus_command(@subscriber_token, COMMAND_HASH)
      buslen = @fb.ecobus_length(@subscriber_token)
      expect( buslen ).to eq( 1 )

      @fb.clear_bus_channel(@subscriber_token)
      buslen = @fb.ecobus_length(@subscriber_token)
      expect( buslen ).to eq( 0 )
    end

  end

end
