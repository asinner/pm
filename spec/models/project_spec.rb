require 'rails_helper'

RSpec.describe Project, :type => :model do
  let(:project) {FactoryGirl.create(:project)}
  
  it 'has valid factory' do
    expect(project).to be_valid
  end
  
  it 'is invalid without a name' do
    project.name = nil
    expect(project).to be_invalid
  end
  
  it 'is invalid without a company' do
    project.company = nil
    expect(project).to be_invalid
  end
end
