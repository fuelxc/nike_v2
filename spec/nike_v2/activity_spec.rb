require 'spec_helper'

describe NikeV2::Activity do
  let(:activity){ build(:activity) }
  
  describe 'fetch_data' do
    before{ VCR.insert_cassette 'activity', record: :new_episodes }
    after{ VCR.eject_cassette }

    it 'should load the activity from the api' do
      activity.load_data.should be_true
      activity.calories.should == 257
    end
  end
end