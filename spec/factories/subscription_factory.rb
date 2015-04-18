FactoryGirl.define do
  factory :subscription do
    company {FactoryGirl.create(:company)}
    plan {FactoryGirl.create(:plan)}
  end
end