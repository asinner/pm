require 'rails_helper'

RSpec.describe "Invitations", :type => :request do
  describe 'sending an invite' do
    context 'when a single email is provided' do
      let(:token) {FactoryGirl.create(:token)}
      
      it 'returns a 201 for a successful invite' do
        post "/api/invitations", {
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
      end
    end
  end
end
