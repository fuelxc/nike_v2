require 'spec_helper'

describe NikeV2::Summary do
  let(:person){ build(:person) }
  
  describe 'new' do
    before{ VCR.insert_cassette 'summary', record: :new_episodes }
    after{ VCR.eject_cassette }

    it 'should return a Summary of user data' do
      person.summary.should be_kind_of(NikeV2::Summary)
      person.summary.experience_types.include?('FUELBAND').should be_true
      person.summary.summaries.length.should == 2
    end
  end
end