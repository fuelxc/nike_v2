require 'spec_helper'

describe NikeV2::Resource do
  it 'should include HTTParty' do
    NikeV2::Resource.should include(HTTParty)
  end

  describe '#base_uri' do
    it 'should be set to https://api.nike.com/v1' do
      NikeV2::Resource.base_uri.should == 'https://api.nike.com/v1'
    end
  end
end