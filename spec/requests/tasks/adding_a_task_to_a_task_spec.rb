require 'rails_helper'

RSpec.describe 'Adding a task to a task', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.last}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project_with_tasks, company: company)}
  let(:task) {project.tasks.last}
  let(:unauthorized_task) {FactoryGirl.create(:task)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/tasks', {
        task_id: task.id,
        description: 'A new task to perform'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      expect(task.tasks.count).to eq(1)
      t = json(response.body)[:task]
      expect(t[:taskable_id]).to eq(task.id)
      expect(t[:taskable_type]).to eq('Task')
      expect(t[:description]).to eq('A new task to perform')
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/tasks', {
        task_id: task.id,
        description: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(task.tasks.count).to eq(0)
    end
  end
  
  context 'with invalid taskable' do
    it 'raises an error' do
      expect {
        post '/api/tasks', {
          invalid_taskable_id: 0,
          description: nil
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/tasks', {
        task_id: task.id,
        description: 'A new task to perform'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(task.tasks.count).to eq(0)
    end
  end
  
  context 'to an unauthorized task' do
    it 'returns a 403' do
      post '/api/tasks', {
        task_id: unauthorized_task.id,
        description: 'A new task to perform'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(task.tasks.count).to eq(0)
    end
  end
end