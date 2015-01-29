require 'rails_helper'

RSpec.describe 'Creating a project', type: :request do
  let(:user) {FactoryGirl.create(:user)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/projects', {
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