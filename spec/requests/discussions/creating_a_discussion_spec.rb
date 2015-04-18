require 'rails_helper'

RSpec.describe 'Creating a discussion', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.last}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:unauthorized_project) {FactoryGirl.create(:project)}
  
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/discussions', {
        project_id: project.id,
        title: 'A discussion about religion & politics'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.discussions.count).to eq(1)
      discussion = json(response.body)[:discussion]
      expect(discussion[:title]).to eq('A discussion about religion & politics')
      expect(discussion[:project_id]).to eq(project.id)
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/discussions', {
        project_id: project.id,
        title: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.discussions.count).to eq(0)
    end
  end

  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/discussions', {
        project_id: project.id,
        title: 'An awesome discussion title'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.discussions.count).to eq(0)
    end
  end

  context 'for an unauthorized project' do
    it 'returns a 403' do
      post '/api/discussions', {
        project_id: unauthorized_project.id,
        title: 'An awesome discsussion title'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.discussions.count).to eq(0)
    end
  end
end
