require 'rails_helper'

RSpec.describe Invitation, :type => :model do
  let(:invitation) {FactoryGirl.create(:invitation)}

  it 'has a valid factory' do
    expect(invitation).to be_valid 
  end
  
  it 'is invalid without a recipient' do
    invitation.recipient = nil;
    expect(invitation).to be_invalid
  end
  
  it 'is invalid without a key' do
    invitation.key = nil;
    expect(invitation).to be_invalid
  end
  
  it 'is invalid without a company' do
    invitation.company = nil
    expect(invitation).to be_invalid
  end
end
