require 'rails_helper'

RSpec.describe Company, :type => :model do
  let(:company) {FactoryGirl.create(:company)}
  
  it 'has a valid factory' do
    expect(company).to be_valid
  end

  it 'is invalid without a name' do
    company.name = nil
    expect(company).to be_invalid
  end
  
  it 'has employees' do
    expect(company).to respond_to(:employees)
  end
end
