require 'rails_helper'

RSpec.describe "Authentications", :type => :request do  
  describe "getting a token" do
    let(:user) {FactoryGirl.create(:user, password: 12345)}
    
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
        token = json(response.body)[:token]
        expect(token[:user][:id]).to eq(user.id)
        expect(token[:string]).to be
        expect(Token.count).to eq(1)
      end
    end
    
    context 'with invalid email and password' do
      it 'returns a 401' do
        post '/api/tokens', {
          email: user.email,
          password: 'WRONGPASSWORD'
        }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(401)
      end
    end
  end

  describe "destroying a token" do
    context "with valid credentials" do
      let(:string) { SecureRandom::uuid }
      let(:token) { FactoryGirl.create(:token, string: string) }
      
      it 'destroys an authentication token' do
        delete "/api/tokens/#{string}"
        expect(response.status).to eq(204)
        expect(Token.count).to eq(0)
      end
    end
  end
end
