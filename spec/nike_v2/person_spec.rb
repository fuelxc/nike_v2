require 'spec_helper'

describe NikeV2::Person do
  let(:access_token){ 'bazquux' }
  let(:person){ build(:person) }

  describe '.new' do
    context 'with an access_token attribute' do
      it 'should return a NikeApi::Person object' do
        person = NikeV2::Person.new(access_token: access_token)
        person.should be_an_instance_of(NikeV2::Person)
      end
    end

    context 'without an access_token attribute' do
      it 'should raise an error' do
        expect{ NikeV2::Person.new }.to raise_error('NikeV2::Person requires an access_token.')
      end
    end
  end

end