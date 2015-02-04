require 'rails_helper'

RSpec.describe 'Creating invitations', type: :request do
  let(:user) {FactoryGirl.create(:user_with_company)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  let(:company) {user.companies.first}
  let(:unauthorized_company) {FactoryGirl.create(:company)}
  
  context 'with valid credentials' do    
    context 'for an authorized company' do
      before {CompanyInvitationWorker.jobs.clear}
      
      context 'and with a single email' do
        it 'returns a 201' do
          post '/api/invitations', {
            company_id: company.id,
            emails: [
              'andrew@example.com'
            ]
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }

          expect(response.status).to eq(201)
          expect(response.content_type).to eq(Mime::JSON)
          expect(Invitation.count).to eq(1)
          invitations = json(response.body)[:invitations]
          expect(invitations[0][:recipient]).to eq('andrew@example.com')
          expect(CompanyInvitationWorker.jobs.size).to eq(1)
          CompanyInvitationWorker.drain
          expect(CompanyInvitationWorker.jobs.size).to eq(0)
        end
      end
      
      context 'and with multiple emails' do
        it  'returns a 201' do
          post '/api/invitations', {
            company_id: company.id,
            emails: [
              'andrew@example.com',
              'andrew2@example.com'
            ]
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }

          expect(response.status).to eq(201)
          expect(response.content_type).to eq(Mime::JSON)
          expect(Invitation.count).to eq(2)
          invitations = json(response.body)[:invitations]
          expect(invitations[0][:recipient]).to eq('andrew@example.com')
          expect(invitations[1][:recipient]).to eq('andrew2@example.com')
          expect(CompanyInvitationWorker.jobs.size).to eq(2)
          CompanyInvitationWorker.drain
          expect(CompanyInvitationWorker.jobs.size).to eq(0)
        end
      end
    end
    
    context 'for an unauthorized company' do
      it 'returns a 403' do
        post '/api/invitations', {
          company_id: unauthorized_company.id,
          emails: [
            'andrew@example.com',
            'andrew2@example.com'
          ]
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(403)
        expect(response.content_type).to eq(Mime::JSON)
      end
    end
  
    context 'for a non-existent company' do
      it 'returns a 404' do
        expect {
          post '/api/invitations', {
            company_id: 0,
            emails: [
              'andrew@example.com',
              'andrew2@example.com'
            ]
          }.to_json, {
            'X-Auth-Token' => token.string,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          } 
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  context 'with invalid credentials' do
    it 'returns a 401' do
      post '/api/invitations', {
        company_id: company.id,
        emails: [
          'andrew@example.com'
        ]
      }.to_json, {
        'X-Auth-Token' => 'BAD CREDENTIALS',
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      expect(response.status).to eq(401)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
end

# RSpec.describe "Creating invitations", :type => :request do
#   describe 'sending an invite' do
#     context 'when a single email is provided' do
#       let(:token) {FactoryGirl.create(:token)}
#       
#       it 'returns a 201 for a successful invite' do
#         post "/api/invitations", {
#           emails: [
#             'andrew@example.com'
#           ]
#         }.to_json, {
#           'X-Auth-Token' => token.string,
#           'Accept' => 'application/json',
#           'Content-Type' => 'application/json'
#         }
#         
#         expect(response.status).to eq(201)
#         expect(response.content_type).to eq(Mime::JSON)
#         expect(Invitation.count).to eq(1)
#         invitations = json(response.body)[:invitations]
#         expect(invitations[0][:recipient]).to eq('andrew@example.com')
#       end
#     end
#   end
# end
