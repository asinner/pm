require 'rails_helper'

RSpec.describe Discussion, :type => :model do
  let(:discussion) {FactoryGirl.create(:discussion)}
  
  it 'has a valid factory' do
    expect(discussion).to be_valid
  end
  
  it 'is invalid without a project' do
    discussion.project = nil
    expect(discussion).to be_invalid
  end
  
  it 'is invalid without a creator' do
    discussion.user = nil
    expect(discussion).to be_invalid
  end
  
  it 'is invalid without a title' do
    discussion.title = nil
    expect(discussion).to be_invalid
  end
  
  it 'has comments' do
    expect(discussion).to respond_to(:comments)
  end
end

