require 'rails_helper'

RSpec.describe 'Creating users', :type => :request do
  context 'with valid information' do
    it 'returns a 201' do
      expect(User.count).to eq(0)
      
      post '/api/users', {
        user: {
          first_name: 'andrew',
          last_name: 'sinner',
          email: 'andrew@example.com',
          password: '123456'
        }
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)
      user = json(response.body)[:user]
      
      expect(user[:first_name]).to eq('andrew')
      expect(user[:last_name]).to eq('sinner')
      expect(user[:email]).to eq('andrew@example.com')
      expect(User.count).to eq(1)
    end
  end
  
  context 'with invalid information' do
    it 'returns a 422' do
      post '/api/users', {
        user: {
          first_name: 'andrew',
          last_name: 'sinner',
          email: 'andrew@example.com'
        }
      }.to_json, {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      expect(response.status).to eq(422)
      expect(response.content_type).to eq(Mime::JSON) 
    end
  end
end
