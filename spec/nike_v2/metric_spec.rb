require 'spec_helper'

describe NikeV2::Metric do
  let(:activity){ build(:activity) }
  
  describe 'fetch_data' do
    before do
      VCR.insert_cassette 'activity', record: :new_episodes
      activity.load_data
    end
    
    after{ VCR.eject_cassette }

    it 'should build the metrics from the activity' do
      metric = activity.metrics.last
      metric.type.should == 'FUEL'
    end    

    it 'should give an array of values during a time range' do
      metric = activity.metrics.last
      metric.during(Time.at(activity.started_at.to_i + (60 * 60)), Time.at(activity.started_at.to_i + (60 * 120) - 1)).length.should == 60
    end

    it 'should total the values during a time range' do
      metric = activity.metrics.last
      metric.total_during(Time.at(activity.started_at.to_i + (60 * 60)), Time.at(activity.started_at.to_i + (60 * 120))).should == 831
    end
  end
end