require 'rails_helper'

RSpec.describe "Companies", :type => :request do
  describe "user can create company" do
    context "when user does not have a company" do
      context "when user supplies valid data" do
        it 'returns a new company' do
          post '/api/companies', {
            name: 'My company'
          }.to_json, {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
          
          expect(response.status).to eq(200)
          expect(response.content_type).to eq(Mime::JSON)
        end
      end
    end
  end
end
