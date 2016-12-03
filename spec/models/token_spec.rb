require 'rails_helper'

RSpec.describe Token, :type => :model do
  let(:string) { SecureRandom::uuid }
  let(:token) { FactoryGirl.create(:token, string: string) }

  it 'is invalid without a unique string' do
    token
    token2 = FactoryGirl.build(:token, string: string)
    expect(token2).to be_invalid
  end

  it 'is invalid without a string' do
    token.string = nil
    expect(token).to be_invalid
  end

  it 'is invalid without a user' do
    token.user = nil
    expect(token).to be_invalid
  end

  it 'is invalid without a expiration date' do
    token.expires_at = nil
    expect(token).to be_invalid
  end
end
