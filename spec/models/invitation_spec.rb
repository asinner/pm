require 'rails_helper'

RSpec.describe Invitation, :type => :model do
  let(:invitation) {FactoryGirl.create(:invitation)}

  it 'is invalid without a recipient' do
    invitation.recipient = nil;
    expect(invitation).to be_invalid
  end

  it 'is invalid without a key' do
    invitation.key = nil;
    expect(invitation).to be_invalid
  end

  it 'has a sender' do
    expect(invitation).to respond_to(:sender)
  end
end
