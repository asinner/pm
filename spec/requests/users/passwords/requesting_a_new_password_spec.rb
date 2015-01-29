require 'rails_helper'

RSpec.describe 'Requesting a new password', type: :request do
  let(:user) {FactoryGirl.create(:user)}
  
  context 'with a valid email' do
    it 'returns a 201' do
      post '/api/password_resets', {
        email: user.email
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      expect(PasswordReset.count).to eq(1)
    end
    
    it 'emails a password reset to the user' do
      expect do
        post '/api/password_resets', {
          email: user.email
        }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      end.to change(ActionMailer::Base.deliveries, :size).by(1)      
    end
  end
  
  context 'with an invalid email' do
    it 'returns a 422' do
      post '/api/password_resets', {
        email: 'BAD EMAIL'
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      expect(PasswordReset.count).to eq(0)
    end
  end
end