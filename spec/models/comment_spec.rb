require 'rails_helper'

RSpec.describe Comment, :type => :model do
  let(:comment) {FactoryGirl.create(:comment)}
  
  it 'has a valid factory' do
    expect(comment).to be_valid
  end
  
  it 'is invalid without a body' do
    comment.body = nil
    expect(comment).to be_invalid
  end
  
  it 'is invalid without a commentable reference' do
    comment.commentable = nil
    expect(comment).to be_invalid
  end
  
  it 'has comments' do
    expect(comment).to respond_to(:comments)
  end
end
