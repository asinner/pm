FactoryGirl.define do
  factory :plan do
    name 'Basic'
    upload_limit {50.gigabytes}
  end
end