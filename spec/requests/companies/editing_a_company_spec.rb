require 'rails_helper'

RSpec.describe 'Editing a company', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:company) {user.companies.first}
  
  context 'without valid credentials' do
    it 'returns a 401' do
      patch "/api/companies/#{company.id}", {
        name: 'Hijacked name'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
  
  context 'that does not belong to me' do
    let(:unauthorized_company) {FactoryGirl.create(:company)}
    
    it 'returns a 403' do
      patch "/api/companies/#{unauthorized_company.id}", {
        name: 'Hijacked name'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
    end
  end

  context 'with valid information' do
    it 'returns a 200' do
      patch "/api/companies/#{company.id}", {
        name: 'Something here'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      company = json(response.body)[:company]
      expect(company[:name]).to eq('Something here')
    end
  end
end