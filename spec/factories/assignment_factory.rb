FactoryGirl.define do
  factory :assignment do
    user {FactoryGirl.create(:user)}
    task {FactoryGirl.create(:task)}
    assigner {FactoryGirl.create(:user)}
  end
end