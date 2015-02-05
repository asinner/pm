require 'rails_helper'

RSpec.describe 'Getting a project', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.first}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:unauthorized_company) {FactoryGirl.create(:company)}
  let(:unauthorized_project) {FactoryGirl.create(:project, company: unauthorized_company)}

  
  context 'that does not exist' do
    it 'returns a 404' do
      expect {
        get "/api/projects/0", nil, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  context 'that a user is authorized for' do
    context 'with a company with a valid subscription' do
      it 'returns a 200' do
        get "/api/projects/#{project.id}", nil, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(200)
        expect(response.content_type).to eq(Mime::JSON)
      end
    end
    
    context 'with a company with an invalid subscription' do
      before {company.update(subscription_status: 'cancel')}
      
      it 'returns a 402' do
        get "/api/projects/#{project.id}", nil, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(402)
        expect(response.content_type).to eq(Mime::JSON)
      end
    end
  end
  
  context 'that a user is not authorized for' do
    it 'returns a 403' do
      get "/api/projects/#{unauthorized_project.id}", nil, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
end