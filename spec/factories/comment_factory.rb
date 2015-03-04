FactoryGirl.define do
  factory :comment do
    commentable {FactoryGirl.create(:discussion)}
    body 'Well this is an example comment body'
    user {FactoryGirl.create(:user)}
  end
end