require 'spec_helper'

describe NikeV2::Base do
  it 'should make its attributes available through accessor methods' do
    base = NikeV2::Base.new(first_name: 'Foo', last_name: 'Bar')
    base.should respond_to(:first_name)
    base.should respond_to(:last_name)
    base.first_name.should == 'Foo'
    base.last_name.should == 'Bar'
  end
end