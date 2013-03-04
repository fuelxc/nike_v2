require 'spec_helper'

describe NikeV2::Activity do
  let(:activity){ build(:activity) }
  
  describe 'fetch_data' do
    before{ VCR.insert_cassette 'activity', record: :new_episodes, :allow_playback_repeats => true }
    after{ VCR.eject_cassette }

    it 'should load the activity metrics from the api' do
      activity.load_data.should be_true
      activity.calories.should == 257
    end

    it 'should load the activity metrics from the api without explicit call' do
      activity.total_fuel.should == 20491.0
    end

    it 'should sum the metrics during a time period' do
      activity.total_fuel_during(Time.parse('2011-08-11T00:00:00'), Time.parse('2011-08-11T01:00:00')).should == 934.0
    end
  end
end