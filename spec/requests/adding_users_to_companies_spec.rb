require 'rails_helper'

RSpec.describe "Adding users to companies", :type => :request do
  describe 'adding a user to a company' do
    context 'when a user supplies valid information' do
      skip it 'adds a new user to the company' do
        let(:invitation) {FactoryGirl.create(:invitation)}
        let(:user) {FactoryGirl.create(:user, company: invitation.company)}
        
        post '/api/joins', {
          first_name: 'Andrew',
          last_name: 'Sinner',
          email: 'andrew@example.com',
          password: '12345',
          key: invitation.key
        }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(201)
        expect(response.content_type).to eq(Mime::JSON)
      end
    end
  end
end
