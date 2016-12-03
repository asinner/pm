require 'rails_helper'

RSpec.describe PasswordReset, type: :model do
  let(:password_reset) {FactoryGirl.create(:password_reset)}

  it 'is invalid without a user' do
    password_reset.user = nil
    expect(password_reset).to be_invalid
  end

  it 'is invalid without a secret' do
    password_reset.secret = nil
    expect(password_reset).to be_invalid
  end

  it 'is invalid without an expiration' do
    password_reset.expires_at = nil
    expect(password_reset).to be_invalid
  end

  it 'has a user' do
    expect(password_reset).to respond_to(:user)
  end
end
