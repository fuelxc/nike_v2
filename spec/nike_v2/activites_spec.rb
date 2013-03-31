require 'spec_helper'

describe NikeV2::Activities do
  let(:person){ build(:person) }
  
  describe 'new from person' do
    before{ VCR.insert_cassette 'activities', record: :new_episodes, :allow_playback_repeats => true }
    after{ VCR.eject_cassette }

    it 'should return an array of Nike::Activity' do
      person.activities.should be_kind_of(NikeV2::Activities)
      person.activities.first.should be_kind_of(NikeV2::Activity)
      person.activities.length.should == 5
    end

    it 'should accept the count parameter and return an array of Nike::Activity' do
      person.activities(:count => 1).should be_kind_of(NikeV2::Activities)
      person.activities(:count => 1).first.should be_kind_of(NikeV2::Activity)
      person.activities(:count => 1).length.should == 1
    end

    it 'should fetch_all and return an array of Nike::Activity' do
      (a = person.activities(:count => 1).fetch_all).should be_kind_of(NikeV2::Activities)
      a.first.should be_kind_of(NikeV2::Activity)
      a.length.should == 3
    end

    it 'should accept the start_date parameter, camelcase it and return an array of Nike::Activity' do
      person.activities(:count => 1, :start_date => '2013-03-29', :end_date => '2013-03-29').should be_kind_of(NikeV2::Activities)
      person.activities(:count => 1).first.should be_kind_of(NikeV2::Activity)
      person.activities(:count => 1).length.should == 1
    end

    it 'should calculate all the fuels' do
      person.activities(:count => 1).total_fuel.should == 20491.0
    end
  end
end