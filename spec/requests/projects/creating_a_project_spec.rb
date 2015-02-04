require 'rails_helper'

RSpec.describe 'Creating a project', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.first}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:unauthorized_company) {FactoryGirl.create(:company)}
  
  context 'for an authorized company' do
    context 'and with a valid subscription' do
      context 'and with valid information' do
        it 'returns a 201' do
          post '/api/projects', {
            company_id: company.id,
            name: 'My first project',
            description: 'An example of sorts'
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }

          expect(response.status).to eq(201)
          expect(response.content_type).to eq(Mime::JSON)
          project = json(response.body)[:project]
          expect(project[:name]).to eq('My first project')
          expect(project[:description]).to eq('An example of sorts')
          expect(Project.count).to eq(1)
        end 
      end

      context 'with invalid information' do
        it 'returns a 422' do
          post '/api/projects', {
            company_id: company.id,
            name: nil,
            description: 'An example of sorts'
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
    
    context 'and with an invalid subscription' do
      before do
        company.update(subscription_status: nil)
      end
      
      it 'returns a 402' do
        post '/api/projects', {
          company_id: company.id,
          name: 'My first project',
          description: 'An example of sorts'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(402)
        expect(response.content_type).to eq(Mime::JSON)
      end
    end
  end

  context 'for an unauthorized company' do
    it 'returns a 403' do
      post '/api/projects', {
        company_id: unauthorized_company.id,
        name: 'My first project',
        description: 'An example of sorts'
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
        post '/api/projects', {
          company_id: 0,
          name: 'My first project',
          description: 'An example of sorts'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        } 
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end