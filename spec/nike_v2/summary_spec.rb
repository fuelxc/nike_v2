require 'spec_helper'

describe NikeV2::Summary do
  let(:person){ build(:person) }
  
  describe 'new' do
    before{ VCR.insert_cassette 'summary', record: :new_episodes, :allow_playback_repeats => true }
    after{ VCR.eject_cassette }

    it 'should return a Summary of user data' do
      person.summary.should be_kind_of(NikeV2::Summary)
      person.summary.activity_types.collect(&:to_s).include?('Fuel Band').should be_true
      person.summary.fuelband.should_not be_nil
    end
  end
end