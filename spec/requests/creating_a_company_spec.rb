require 'rails_helper'

RSpec.describe "Creating a company", :type => :request do
  describe "user can create company" do
    context "when user does not have a company" do
      let(:token) { FactoryGirl.create(:token) }
      context "when user supplies valid data" do
        it 'returns a new company' do
          post '/api/companies', {
            name: 'My company',
            token: token.string
          }.to_json, {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
          
          expect(response.status).to eq(201)
          expect(response.content_type).to eq(Mime::JSON)
          company = json(response.body)[:company]
          expect(company[:name]).to eq('My company')
          expect(Company.count).to eq(1)
        end
      end
      
      context "when user supplies invalid data" do
        it "returns a 422" do
          post '/api/companies', {
            name: nil,
            token: token.string
          }.to_json, {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
          
          expect(response.status).to eq(422)
          expect(Token.count).to eq(0)
        end
      end
    end
  end
end
