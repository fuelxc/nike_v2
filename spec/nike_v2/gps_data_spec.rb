require 'spec_helper'

describe NikeV2::Activity do
  let(:activity){ build(:activity) }
  
  describe 'reload' do
    before{ VCR.insert_cassette 'gps_data', record: :new_episodes }
    after{ VCR.eject_cassette }

    it 'should load the activity from the api' do
      activity.gps_data.should be_an_instance_of(NikeV2::GpsData)
      activity.gps_data.elevation_loss.should == 54.089367
    end
  end
end