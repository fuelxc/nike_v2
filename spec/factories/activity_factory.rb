FactoryGirl.define do
  factory :activity, class: NikeV2::Activity do
    person { FactoryGirl.build(:person)}
    activityId '91b501dc-4a38-44aa-b537-6095418713d8'
    initialize_with { new(person: person, 'activityId' => activityId) }
  end
end