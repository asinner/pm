require 'rails_helper'

RSpec.describe 'Editing users', :type => :request do
  let(:user) {FactoryGirl.create(:user)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  
  context 'with valid information' do    
    it 'returns a 200' do
      patch "/api/users/#{user.id}", {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com'
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      user = json(response.body)[:user]
      expect(user[:first_name]).to eq('John')
      expect(user[:last_name]).to eq('Doe')
      expect(user[:email]).to eq('john@example.com')
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      patch "/api/users/#{user.id}", {
        first_name: 'John',
        last_name: 'Doe',
        email: nil
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
    end
  end
end
