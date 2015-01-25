require 'rails_helper'

RSpec.describe 'Creating a company', type: :request do  
  context 'when a user does not already have a company' do
    let(:user) {FactoryGirl.create(:user, company: nil)}
    let(:token) {FactoryGirl.create(:token, user: user)}
    
    context 'and with valid information' do
      it 'returns a 201' do
        post '/api/companies', {
          name: 'My company'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(201)
        expect(response.content_type).to eq(Mime::JSON)
        company = json(response.body)[:company]
        expect(company[:name]).to eq('My company')
        expect(Company.count).to eq(1)
      end
    end
    
    context 'and with invalid information' do
      it 'returns a 422' do
        post '/api/companies', {
          name: nil,
        }.to_json, {
          'X-Auth-Token' => token.string,            
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(422)
        expect(response.content_type).to eq(Mime::JSON)
        expect(Company.count).to eq(0)
      end
    end
  end
  
  context 'when a user already has a company' do
    let(:user) {FactoryGirl.create(:user)}
    let(:token) {FactoryGirl.create(:token, user: user)}
    
    it 'returns a 422' do
      post '/api/companies', {
        name: 'My new company to replace old company!'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(Company.count).to eq(1);
    end
  end
end
