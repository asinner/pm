FactoryGirl.define do
  sequence :email do |n|
    "andrew#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user do
    first_name "Andrew"
    last_name "Sinner"
    sequence(:email)
    password '12345678'
    company
  end
end