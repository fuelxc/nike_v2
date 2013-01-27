FactoryGirl.define do
  factory :person, class: NikeV2::Person do
    access_token 'foobar'
    initialize_with { new(access_token: access_token) }
  end
end