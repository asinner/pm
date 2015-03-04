require 'rails_helper'

RSpec.describe 'Adding a comment to a discussion', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:company) {user.companies.last}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:discussion) {FactoryGirl.create(:discussion, project: project)}
  let(:unauthorized_discussion) {FactoryGirl.create(:discussion)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/comments', {
        discussion_id: discussion.id,
        body: 'A really short comment about things related to a discussion'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      expect(discussion.comments.count).to eq(1)
      comment = json(response.body)[:comment]
      expect(comment[:commentable_type]).to eq('Discussion')
      expect(comment[:commentable_id]).to eq(discussion.id)
      expect(comment[:body]).to eq('A really short comment about things related to a discussion')
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/comments', {
        discussion_id: discussion.id,
        body: ''
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(discussion.comments.count).to eq(0)
    end
  end
  
  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/comments', {
        discussion_id: discussion.id,
        body: 'Another comment'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(discussion.comments.count).to eq(0)
    end
  end
  
  context 'that a user is not authorized for' do
    it 'returns a 403' do
      post '/api/comments', {
        discussion_id: unauthorized_discussion.id,
        body: 'Another comment'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(discussion.comments.count).to eq(0)
    end
  end
  
  context 'that does not exist' do
    it 'returns a 404' do
      expect {
        post '/api/comments', {
          discussion_id: 0,
          body: 'Another comment'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        } 
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end