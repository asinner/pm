require 'rails_helper'

RSpec.describe 'Joining a company', type: :request do
  let(:inviting_company) {FactoryGirl.create(:company)}
  
  context 'with an existing user' do
    let(:company) {FactoryGirl.create(:company)}
    let(:user) {FactoryGirl.create(:user)}
    let(:token) {FactoryGirl.create(:token, user: user)}
    
    before do
      user.companies << company
    end
    
    context 'and with a valid invitation' do
      let(:invitation) {FactoryGirl.create(:invitation, company: inviting_company, recipient: user.email)}

      before do
        invitation.recipient = user.email
      end
      
      it 'returns a 201' do
        post '/api/companies_users', {
          key: invitation.key
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(201)
        expect(response.content_type).to eq(Mime::JSON)
        expect(CompaniesUser.count).to eq(2)
        expect(user.companies).to include(inviting_company)
      end
    end
    
    context 'and with an invalid invitation' do
      it 'returns a 422' do
        post '/api/companies_users', {
          key: 'BAD_INVITATION_KEY'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(422)
        expect(response.content_type).to eq(Mime::JSON)
        expect(CompaniesUser.count).to eq(1)
      end
    end
  end  
end