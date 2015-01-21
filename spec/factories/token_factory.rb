FactoryGirl.define do
  factory :token do
    string SecureRandom::uuid
    expires_at 30.days.from_now
    user
  end
end