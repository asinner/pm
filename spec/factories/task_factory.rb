FactoryGirl.define do
  factory :task do
    creator {FactoryGirl.create(:user)}
    description "Some really stupid hard description"
    taskable {FactoryGirl.create(:project)}
  end
end