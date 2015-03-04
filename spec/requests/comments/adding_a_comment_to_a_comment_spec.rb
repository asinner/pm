require 'rails_helper'

RSpec.describe 'Adding a comment to a comment', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:company) {user.companies.last}
  let(:project) {FactoryGirl.create(:project, company: company)}
  let(:discussion) {FactoryGirl.create(:discussion, project: project)}
  let(:comment) {FactoryGirl.create(:comment, commentable: discussion)}
  let(:unauthorized_comment) {FactoryGirl.create(:comment)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/comments', {
        comment_id: comment.id,
        body: 'A comment on a comment'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      expect(comment.comments.count).to eq(1)
      c = json(response.body)[:comment]
      expect(c[:body]).to eq("A comment on a comment")
      expect(c[:commentable_type]).to eq('Comment')
      expect(c[:commentable_id]).to eq(comment.id)
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/comments', {
        comment_id: comment.id,
        body: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(comment.comments.count).to eq(0)
    end
  end
  
  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/comments', {
        comment_id: comment.id,
        body: 'A comment on a comment'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(comment.comments.count).to eq(0)
    end
  end
  
  context 'that a user is not authorized for' do
    it 'returns a 403' do
      post '/api/comments', {
        comment_id: unauthorized_comment.id,
        body: 'A comment on a comment'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(comment.comments.count).to eq(0)
    end
  end
  
  context 'that does not exist' do
    it 'returns a 404' do
      expect {
        post '/api/comments', {
          comment_id: 0,
          body: 'A comment on a comment'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        } 
      }.to raise_error
    end
  end
end