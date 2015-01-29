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

  context 'with valid reset secret' do
    let(:reset) {FactoryGirl.create(:password_reset, user: user, secret: SecureRandom::uuid)}
    
    context 'that is not expired' do
      context 'and with valid password' do
        it 'returns a 200' do
          post '/api/passwords', {
            password: new_password,
            secret: reset.secret
          }.to_json, {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
          
          expect(response.status).to eq(200)
          expect(response.content_type).to eq(Mime::JSON)
          u = User.find(user.id)
          expect(u.authenticate(new_password)).to be
        end
      end
      
      context 'and with invalid password' do
        it 'returns a 422' do
          post '/api/passwords', {
            password: nil,
            secret: reset.secret
          }.to_json, {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
          
          expect(response.status).to eq(422)
          expect(response.content_type).to eq(Mime::JSON)
          u = User.find(user.id)
          expect(u.authenticate(nil)).to_not be
        end
      end
    end
    
    context 'that is expired' do
      let(:reset) {FactoryGirl.create(:password_reset, user: user, secret: SecureRandom::uuid, expires_at: 2.days.ago)}
      context 'and with valid password' do
        it 'returns a 422' do
          post '/api/passwords', {
            password: new_password,
            secret: reset.secret
          }.to_json, {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }

          expect(response.status).to eq(422)
          expect(response.content_type).to eq(Mime::JSON)
          u = User.find(user.id)
          expect(u.authenticate(old_password)).to be
        end
      end
      
      context 'and with invalid password' do
        it 'returns a 422' do
          post '/api/passwords', {
            password: new_password,
            secret: reset.secret
          }.to_json, {
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
  end
  
  context 'with invalid reset secret' do;
    let(:reset) {FactoryGirl.create(:password_reset, user: user, secret: SecureRandom::uuid)}
    context 'returns a 422' do
      it 'returns a 422' do
        post "/api/passwords", {
          password: new_password,
          secret: 'MyReallyBadSecret'
        }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }

        expect(response.status).to eq(404)
        expect(response.content_type).to eq(Mime::JSON)
        u = User.find(user.id)
        expect(u.authenticate(old_password)).to be
      end
    end
  end
end