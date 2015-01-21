require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.create(:user, email: 'andrew@example.com') }
  
  it 'has a valid factory' do
    expect(user).to be_valid
  end
  
  it 'is invalid without a first name' do
    user.first_name = nil
    expect(user).to_not be_valid
  end
  
  it 'is invalid without a last name' do
    user.last_name = nil
    expect(user).to_not be_valid
  end
  
  it 'is invalid without an email' do
    user.email = nil
    expect(user).to_not be_valid
  end
  
  it 'is invalid with a non-unique email' do
    user # Ensure user is created due to lazy loading
    user2 = FactoryGirl.build(:user, email: 'andrew@example.com')
    expect(user2).to_not be_valid
  end
  
  it 'is invalid without a password' do
    user.password = nil
    expect(user).to_not be_valid
  end
  
  it 'is invalid without a long password' do
    user.password = '1234'
    expect(user).to_not be_valid
  end
  
  it 'has a company' do
    expect(user).to respond_to(:company)
  end
end
