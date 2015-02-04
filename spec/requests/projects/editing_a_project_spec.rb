require 'rails_helper'

RSpec.describe 'Editing a project', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.first}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:unauthorized_project) {FactoryGirl.create(:project)}
  let(:new_name) {'An updated project name'}
  let(:new_description) {'An updated description'}
  
  context 'that a user is authorized for' do
    context 'for a company with a valid subscription' do
      context 'and with valid information' do
        it 'returns a 200' do
          patch "/api/projects/#{project.id}", {
            name: new_name,
            description: new_description
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }

          expect(response.status).to eq(200)
          expect(response.content_type).to eq(Mime::JSON)
          project = json(response.body)[:project]
          expect(project[:name]).to eq(new_name)
          expect(project[:description]).to eq(new_description)
        end
      end      
    
      context 'and with invalid information' do
        it 'returns a 422' do
          patch "/api/projects/#{project.id}", {
            name: nil,
            description: new_description
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
    
    context 'for a company with an invalid subscription' do
      before {company.update(subscription_status: nil)}
      
      it 'returns a 402' do
        patch "/api/projects/#{project.id}", {
          name: new_name,
          description: new_description
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
  
  context 'that a user is not authorized for' do
    it 'returns a 403' do
      patch "/api/projects/#{unauthorized_project.id}", {
        name: new_name,
        description: new_description
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
  
  context 'that does not exist' do
    it 'returns a 404' do
      expect {
        patch "/api/projects/0", {
          name: new_name,
          description: new_description
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end  
end