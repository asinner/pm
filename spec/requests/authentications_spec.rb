require 'rails_helper'

RSpec.describe "Authentications", :type => :request do  
  describe "getting a token" do
    
    let(:user) { FactoryGirl.create(:user, password: 12345) }
    
    context 'with valid email and password' do
      it 'returns an authentication token' do
        post '/api/tokens', {
          email: user.email,
          password: '12345'
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
