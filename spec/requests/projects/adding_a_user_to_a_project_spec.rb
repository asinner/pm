require 'rails_helper'

RSpec.describe 'Adding a user to a project', type: :request do
  let(:user)          {FactoryGirl.create(:user_with_company)}
  let(:company)       {user.companies.first}
  let(:invited_user)  {FactoryGirl.create(:user)}
  let(:token)         {FactoryGirl.create(:token, user: user)}
  let(:project)       {FactoryGirl.create(:project, company: company)}
    
  context 'that belongs to the sending users list of companies' do
    context 'and that belongs to the invited users list of companies' do
      before {invited_user.companies << company}

      context 'and that the invited user is not already joined with' do
        it 'returns a 201' do
          post '/api/projects_users', {
            project_id: project.id,
            user_id: invited_user.id
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
        
          expect(response.status).to eq(201)
          expect(response.content_type).to eq(Mime::JSON)
          expect(invited_user.projects.count).to eq(1)
          expect(project.team).to include(invited_user)
        end
      end
    
      context 'and that the invited user is already joined with' do
        before {invited_user.projects << project}
      
        it 'returns a 422' do
          post '/api/projects_users', {
            project_id: project.id,
            user_id: invited_user.id
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
        
          expect(response.status).to eq(422)
          expect(response.content_type).to eq(Mime::JSON)
          expect(invited_user.projects.count).to eq(1)
          expect(project.team).to include(invited_user)
        end
        
      end
    end
    
    context 'but doesnt belong to the invited users list of companies' do
      it 'returns a 403' do
        post '/api/projects_users', {
          project_id: project.id,
          user_id: invited_user.id
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(403)
        expect(response.content_type).to eq(Mime::JSON)
        expect(invited_user.projects.count).to eq(0)
        expect(project.team).to_not include(invited_user)
      end
    end
  end
  
  context 'that does not belong to the sending users list of companies' do
    it 'returns a 403' do
      post '/api/projects_users', {
        project_id: project.id,
        user_id: invited_user.id
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    
      expect(response.status).to eq(403)
      expect(response.content_type).to eq(Mime::JSON)
      expect(invited_user.projects.count).to eq(0)
      expect(project.team).to_not include(invited_user)
    end
  end

end