require 'rails_helper'

RSpec.describe Company, :type => :model do
  let(:company) {FactoryGirl.create(:company)}

  it 'is invalid without a name' do
    company.name = nil
    expect(company).to be_invalid
  end

  it 'has users' do
    expect(company).to respond_to(:users)
  end

  it 'has invitations' do
    expect(company).to respond_to(:invitations)
  end

  it 'has projects' do
    expect(company).to respond_to(:projects)
  end

  it 'can determine if it has space for an upload' do
    expect(company).to respond_to(:can_store?)
  end

  it 'has a plan' do
    expect(company).to respond_to(:plan)
  end
end
