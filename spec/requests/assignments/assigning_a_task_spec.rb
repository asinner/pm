require 'rails_helper'

RSpec.describe 'Assigning a user to a task', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.last}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:task) {FactoryGirl.create(:task, taskable: project)}
  let(:unauthorized_task) {FactoryGirl.create(:task)}
  let(:unauthorized_user) {FactoryGirl.create(:user)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/assignments', {
        task_id: task.id,
        user_id: user.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      assignment = json(response.body)[:assignment]
      expect(Assignment.count).to eq(1)
      expect(assignment[:task_id]).to eq(task.id)
      expect(assignment[:user_id]).to eq(user.id)
      expect(user.tasks).to include(task)
      expect(task.users).to include(user)
    end
  end
  
  context 'with invalid information (no user id passed)' do
    it 'returns a 404' do
      expect {
        post '/api/assignments', {
          task_id: task.id,
          user_id: nil
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        } 
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  context 'with invalid information (no task id passed)' do
    it 'returns a 404' do
      expect {
        post '/api/assignments', {
          task_id: nil,
          user_id: user.id
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
      post '/api/assignments', {
        task_id: task.id,
        user_id: user.id
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(Assignment.count).to eq(0)
    end
  end
  
  context 'that the user is unauthorized for' do
    it 'returns a 403' do
      post '/api/assignments', {
        task_id: unauthorized_task.id,
        user_id: user.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(Assignment.count).to eq(0)
    end
  end
 
  context 'when the user does not belong to the assigners company' do
    it 'returns a 403' do
      post '/api/assignments', {
        task_id: task.id,
        user_id: unauthorized_user.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      assignment = json(response.body)[:assignment]
      expect(Assignment.count).to eq(0)
    end
  end
end