require 'rails_helper'

RSpec.describe 'Inviting a user to join a company', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:company) {user.companies.first}
  let(:unauthorized_company) {FactoryGirl.create(:company)}
  let(:recipient) {'andrew@example.com'}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/company_invitations', {
        company_id: company.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      invitation = json(response.body)[:invitation]
      expect(invitation[:recipient]).to eq(recipient)
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/company_invitations', {
        company_id: company.id,
        recipient: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(0).to eq(Invitation.count)
    end
  end
  
  context 'without valid credentials' do
    it 'returns a 401' do
      post '/api/company_invitations', {
        company_id: company.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => 'BAD TOKEN',
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(0).to eq(Invitation.count)
    end
  end
  
  context 'for an unauthorized company' do
    it 'returns a 403' do
      post '/api/company_invitations', {
        company_id: unauthorized_company.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(0).to eq(Invitation.count)
    end
  end

  context 'for a non-existent company' do
    it 'returns a 404' do
      expect {
        post '/api/company_invitations', {
          company_id: 0,
          recipient: recipient
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        } 
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect(0).to eq(Invitation.count)
    end
  end
end
