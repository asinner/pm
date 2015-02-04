require 'rails_helper'

RSpec.describe 'Creating a company', type: :request do
  let(:user) {FactoryGirl.create(:user)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  
  context 'with valid credentials' do
    context 'and with valid information' do
      it 'returns a 201' do
        post '/api/companies', {
          name: 'My new company'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(201)
        expect(response.content_type).to eq(Mime::JSON)
        company = json(response.body)[:company]
        expect(company[:name]).to eq('My new company')
        c = Company.find(company[:id])
        expect(user.companies).to include(c)
      end
    end

    context 'and with invalid information' do
      it 'returns a 422' do
        post '/api/companies', {
          name: nil
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(422)
        expect(response.content_type).to eq(Mime::JSON)
        expect(user.companies).to be_empty
      end
    end
  end
  
  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/companies', {
        name: nil
      }.to_json, {
        'X-Auth-Token' => 'INVALID CREDENTIALS',
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
end
