require 'spec_helper'

describe NikeV2::Metrics do
  let(:activity){ build(:activity) }
  
  describe 'fetch_data' do
    before do
      VCR.insert_cassette 'activity', record: :new_episodes, :allow_playback_repeats => true
      activity.load_data
    end
    
    after{ VCR.eject_cassette }

    it 'should build the metrics from the activity' do
      activity.metrics.length.should == 2
    end

    it 'should sum the metrics of a given type' do
      activity.metrics.total_distance.should == 6.5058
    end
  end
end