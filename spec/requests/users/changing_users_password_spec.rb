require 'rails_helper'

RSpec.describe 'Changing users password', type: :request do
  let(:old_password) {'12345678'}
  let(:new_password) {'MyNewPassword'}
  let(:user) {FactoryGirl.create(:user, password: old_password)}
  let(:token) {FactoryGirl.create(:token, user: user)}
  
  context 'with valid old password' do
    context 'and with valid new password' do
      it 'returns a 200' do
        expect(user.authenticate(old_password)).to be

        patch "/api/passwords", {
          old_password: old_password,
          new_password: new_password
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(200)
        expect(response.content_type).to eq(Mime::JSON)
        u = User.find(user.id)
        expect(u.authenticate(new_password)).to be
      end
    end
    
    context 'and with invalid new password' do
      it 'returns a 422' do
        expect(user.authenticate(old_password)).to be

        patch "/api/passwords", {
          old_password: old_password,
          new_password: nil
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(422)
        expect(response.content_type).to eq(Mime::JSON)
        u = User.find(user.id)
        expect(u.authenticate(old_password)).to be
      end
    end
  end

  context 'with invalid old password' do
    it 'returns a 422' do
      patch "/api/passwords", {
        old_password: 'bad-old-password',
        new_password: new_password
      }.to_json, {
        'X-Auth-Token' => token.string,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON)
      u = User.find(user.id)
      expect(u.authenticate(old_password)).to be
    end
  end
end