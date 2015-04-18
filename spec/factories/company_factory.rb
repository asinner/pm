FactoryGirl.define do
  factory :company do
    name 'My awesome company'
    plan {FactoryGirl.create(:plan)}
    subscription_status 'active'
  end
end