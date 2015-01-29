require 'rails_helper'

RSpec.describe 'Editing a project', type: :request do
  let(:user) {FactoryGirl.create(:user)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project, company: user.company)}
  let(:new_name) {'An updated project name'}
  let(:new_description) {'An updated description'}
  
  context 'with valid information' do
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
  
  context 'with invalid information' do
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