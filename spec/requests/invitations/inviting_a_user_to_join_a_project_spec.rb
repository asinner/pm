require 'rails_helper'

RSpec.describe 'Inviting a user to join a project', type: :request do
  let(:user)      {FactoryGirl.create(:user_with_company)}
  let(:company)   {user.companies.first}
  let(:project)   {FactoryGirl.create(:project, company: company)}
  let(:unauthorized_project) {FactoryGirl.create(:project)}
  let(:token)     {FactoryGirl.create(:token, user: user)}
  let(:recipient) {'andrew@example.com'}
  
  context 'with valid information' do
    it 'returns a 201' do
      post '/api/project_invitations', {
        project_id: project.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      invitation = json(response.body)[:invitation]
      expect(recipient).to eq(invitation[:recipient])
      expect(1).to eq(Invitation.count)
      inv = Invitation.last
      expect(project.class.to_s).to eq(inv.invitable_type)
      expect(project.id).to eq(inv.invitable_id)
    end
  end

  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/project_invitations', {
        project_id: project.id,
        recipient: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(0).to eq(Invitation.count)
    end
  end
  
  context 'when the the user does not exist' do
    it 'returns a 201' do
      post '/api/project_invitations', {
        project_id: project.id,
        recipient: 'non-existent-user@example.com'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end

  context 'without valid credentials' do
    it 'returns a 401' do
      post '/api/project_invitations', {
        project_id: project.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => 'BAD TOKEN',
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
      expect(0).to eq(Invitation.count)
    end
  end
  
  context 'for an unauthorized project' do
    it 'returns a 403' do
      post '/api/project_invitations', {
        project_id: unauthorized_project.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(0).to eq(Invitation.count)
    end
  end

  context 'for a non-existent project' do
    it 'returns a 404' do
      expect {
        post '/api/project_invitations', {
          project_id: 0,
          recipient: recipient
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect(0).to eq(Invitation.count)
    end
  end

  context 'for an inactive company' do
    before {company.update(subscription_status: 'cancel')}
    
    it 'returns a 402' do
      post '/api/project_invitations', {
        project_id: project.id,
        recipient: recipient
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(402)
      expect(response.content_type).to eq(Mime::JSON)
      expect(Invitation.count).to eq(0)
    end
  end
end
