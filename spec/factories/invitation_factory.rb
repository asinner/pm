FactoryGirl.define do
  factory :invitation do
    recipient 'andrew@example.com'
    key SecureRandom::uuid
    company
  end
end