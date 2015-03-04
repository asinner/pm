require 'rails_helper'

RSpec.describe 'Editing a task', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.last}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:project) {FactoryGirl.create(:project_with_tasks, company: company)}
  let(:task) {project.tasks.last}
  
  context 'with valid information' do
    it 'returns a 200' do
      put "/api/tasks/#{task.id}", {
        description: 'A brand new title!'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      task = json(response.body)[:task]
      expect(task[:description]).to eq('A brand new title!');
    end
  end
  
  context 'with invalid information' do
    it 'returns a 200' do
      put "/api/tasks/#{task.id}", {
        description: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end

  context 'without credentials' do
    it 'returns a 401' do
      put "/api/tasks/#{task.id}", {
        description: 'A brand new title!'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
  
  context 'for a company with an expired subscription' do
    before {company.update(subscription_status: 'cancel')}
    it 'returns a 402' do
      put "/api/tasks/#{task.id}", {
        description: 'A brand new title!'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(402)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end

  context 'that does not exist' do
    it 'returns a 404' do
      expect {
        put "/api/tasks/0", {
          description: 'A brand new title!'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        } 
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end