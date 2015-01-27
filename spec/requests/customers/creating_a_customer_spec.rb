require 'rails_helper'

RSpec.describe 'Creating a customer', type: :request do
  let(:stripe_helper) {StripeMock.create_test_helper}
  let(:card) {stripe_helper.generate_card_token}
  let(:user) {FactoryGirl.create(:user)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  
  before {StripeMock.start}
  after {StripeMock.stop}
  
  context 'with valid card' do
    it 'returns a 200' do
      post "/api/customers", {
        card: card
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      company = Company.last
      expect(company.stripe_customer_id).to be
    end
  end
  
  context 'with invalid card' do
    it 'returns a 422' do
      post "/api/customers", {
        card: 'Bad card'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      company = Company.last
      expect(company.stripe_customer_id).to be_nil
    end
  end
end