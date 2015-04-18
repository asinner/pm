FactoryGirl.define do
  factory :upload do
    title 'An awesome image'
    mime_type 'image/png'
    attachable {FactoryGirl.create(:project)}
    user {FactoryGirl.create(:user)}
    size {rand(1..50).megabytes}
    url "example.com/image.jpg"
    key SecureRandom::hex(10)
  end
end