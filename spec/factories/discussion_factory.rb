FactoryGirl.define do
  factory :discussion do
    project {FactoryGirl.create(:project)}
    user {FactoryGirl.create(:user)}
    title 'A discussion of all things that matter'
  end
end