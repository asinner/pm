require 'rails_helper'

RSpec.describe 'Creating a subscription', type: :request do
  let(:stripe_helper) {StripeMock.create_test_helper}
  before {StripeMock.start}
  after {StripeMock.stop}
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.first}
  let(:unauthorized_company) {FactoryGirl.create(:company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:plan) {Stripe::Plan.create(amount: 4900, interval: 'month', id: 'p1', currency: 'usd', name: 'company')}
  let(:card) {stripe_helper.generate_card_token}
  let(:customer) {Stripe::Customer.create(card: card)}
  
  context 'for an authorized company' do
    context 'with valid information' do
      it 'returns a 200' do
        post '/api/subscriptions/', {
          company_id: company.id,
          customer: customer,
          plan: plan.id
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(200)
        expect(response.content_type).to eq(Mime::JSON)
        c = Company.last
        expect(c.stripe_subscription_id).to be
        expect(c.stripe_plan_id).to eq('p1')
        expect(c.subscription_status).to eq('active')
      end
    end
  
    context 'with invalid customer' do
      it 'returns a 422' do
        post '/api/subscriptions/', {
          company_id: company.id,
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
          company_id: company.id,
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
  
  context 'for an unauthorized company' do
    it 'returns a 403' do
      post '/api/subscriptions/', {
        company_id: unauthorized_company.id,
        customer: customer,
        plan: plan.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end

  context 'for a company that does not exist' do
    it 'returns a 404' do
      expect {
        post '/api/subscriptions/', {
          company_id: 0,
          customer: customer,
          plan: plan.id
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end