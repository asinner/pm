FactoryGirl.define do
  factory :password_reset do
    user
    secret SecureRandom::uuid
    expires_at 2.days.from_now
  end
end