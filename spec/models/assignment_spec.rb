require 'rails_helper'

RSpec.describe Assignment, :type => :model do
  let(:assignment) {FactoryGirl.create(:assignment)}
  
  it 'has a valid factory' do
    expect(assignment).to be_valid
  end
  
  it 'is invalid without a user' do
    assignment.user = nil
    expect(assignment).to be_invalid
  end
  
  it 'is invalid without a task' do
    assignment.task = nil
    expect(assignment).to be_invalid
  end
  
  it 'is invalid without an assigner' do
    assignment.assigner = nil
    expect(assignment).to be_invalid
  end
end
