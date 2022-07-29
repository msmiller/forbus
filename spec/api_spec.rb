# frozen_string_literal: true

# This tests set up and anything sent across the ecosystem list

RSpec.describe 'Api' do

  before :each do
    setup_redis
    @fb = FORbus.new
  end

  context "site api" do

    it "can get associated site data" do
      @fb.set_site_hash( SITE_HASH )

      result = @fb.site(method: :get)
      ap result
    end

    it "can set associated site data" do
      @fb.set_site_hash( SITE_HASH )
      @fb.site(method: :put, data: SITE_HASH_2)
      result = @fb.site(method: :get)
      ap result
    end

    it "can detect a bogus method" do
      @fb.set_site_hash( SITE_HASH )
      expect{ @fb.site(method: :update) }.to raise_error('Illegal method')
    end

  end

end
