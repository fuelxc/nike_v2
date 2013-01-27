require 'spec_helper'

describe NikeV2::Activities do
  let(:person){ build(:person) }
  
  describe 'new from person' do
    before{ VCR.insert_cassette 'activities', record: :new_episodes }
    after{ VCR.eject_cassette }

    it 'should return an array of Nike::Activity' do
      person.activities.should be_kind_of(NikeV2::Activities)
      person.activities.first.should be_kind_of(NikeV2::Activity)
      person.activities.length.should == 5
    end
  end
end