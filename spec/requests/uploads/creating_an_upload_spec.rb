require 'rails_helper'

RSpec.describe 'Creating an upload', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:company) {user.companies.last}
  let(:project) {FactoryGirl.create(:project, company: company)}  
  let(:unauthorized_project) {FactoryGirl.create(:project)}
  
  context 'with valid information' do
    it 'returns a 201' do
      post "/api/uploads", {
        project_id: project.id,
        title: 'Andrews upload',
        size: 5.megabytes,
        mime_type: 'image/jpeg'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      upload = json(response.body)[:upload]
      expect(upload[:title]).to eq('Andrews upload')
      expect(upload[:size]).to eq(5.megabytes)
      expect(upload[:mime_type]).to eq('image/jpeg')
      expect(upload[:attachable_type]).to eq(project.class.to_s)
      expect(upload[:attachable_id]).to eq(project.id)
      expect(project.uploads.count).to eq(1)
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post "/api/uploads", {
        project_id: project.id,
        title: '',
        size: 5.megabytes,
        mime_type: 'image/jpeg'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.uploads.count).to eq(0)
    end
  end
    
  context 'for an unauthorized project' do
    it 'returns a 403' do
      post "/api/uploads", {
        project_id: unauthorized_project.id,
        title: '',
        size: 5.megabytes,
        mime_type: 'image/jpeg'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(project.uploads.count).to eq(0)
    end
  end
  
  context 'with invalid credentials' do
     it 'returns a 401' do
       post "/api/uploads", {
         project_id: unauthorized_project.id,
         title: 'adsfasd',
         size: 5.megabytes,
         mime_type: 'image/jpeg'
       }.to_json, {
         'Accept' => 'application/json',
         'Content-Type' => 'application/json'
       }

       expect(response.status).to eq(401)
       expect(response.content_type).to eq(Mime::JSON)
       expect(project.uploads.count).to eq(0)
     end
  end
  
end