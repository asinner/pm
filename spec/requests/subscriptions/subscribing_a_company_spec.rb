require 'rails_helper'

RSpec.describe 'Creating a subscription', type: :request do
  let(:stripe_helper) {StripeMock.create_test_helper}
  before {StripeMock.start}
  after {StripeMock.stop}
  let(:user) {FactoryGirl.create(:user)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:plan) {Stripe::Plan.create(amount: 4900, interval: 'month', id: 'p1', currency: 'usd', name: 'company')}
  let(:card) {stripe_helper.generate_card_token}
  let(:customer) {Stripe::Customer.create(card: card)}
  
  context 'with valid information' do
    it 'returns a 200' do
      post '/api/subscriptions/', {
        customer: customer,
        plan: plan.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      company = Company.last
      expect(company.stripe_subscription_id).to be
      expect(company.stripe_plan_id).to eq('p1')
    end
  end
  
  context 'with invalid customer' do
    it 'returns a 422' do
      post '/api/subscriptions/', {
        customer: {
          id: "BAD_CUSTOMER_ID"
        },
        plan: plan.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)      
    end
  end
  
  context 'with invalid plan' do
    it 'returns a 422' do
      post '/api/subscriptions/', {
        customer: customer,
        plan: 'SOME BAD PLAN ID'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)      
    end
  end
end