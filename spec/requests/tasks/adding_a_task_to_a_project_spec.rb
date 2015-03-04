require 'rails_helper'

RSpec.describe 'Adding a task to a project', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.last}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:unauthorized_project) {FactoryGirl.create(:project)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/tasks', {
        project_id: project.id,
        description: 'A new task to perform'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.tasks.count).to eq(1)
      t = json(response.body)[:task]
      expect(t[:taskable_id]).to eq(project.id)
      expect(t[:taskable_type]).to eq('Project')
      expect(t[:description]).to eq('A new task to perform')
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/tasks', {
        project_id: project.id,
        description: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.tasks.count).to eq(0)
    end
  end
  
  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/tasks', {
        project_id: project.id,
        description: 'A new task to perform'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.tasks.count).to eq(0)
    end
  end
  
  context 'to an unauthorized project' do
    it 'returns a 403' do
      post '/api/tasks', {
        project_id: unauthorized_project.id,
        description: 'A new task to perform'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.tasks.count).to eq(0)
    end
  end
end