require 'rails_helper'

RSpec.describe "Creating a company", :type => :request do
  describe "user can create company" do
    context "when user does not have a company" do
      let(:user) {FactoryGirl.create(:user, company: nil)}
      let(:token) { FactoryGirl.create(:token, user: user) }
      context "when user supplies valid data" do
        it 'returns a new company' do
          post '/api/companies', {
            name: 'My company'
          }.to_json, {
            'X-Auth-Token' => token.string,
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
          }.to_json, {
            'X-Auth-Token' => token.string,            
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
          
          expect(response.status).to eq(422)
          expect(Company.count).to eq(0)
        end
      end
    end
  end

  describe "user cannot create a company" do
    context "when user already has a company" do
      let(:token) {FactoryGirl.create(:token)}
      
      it "returns an error when creating a company" do
        post '/api/companies', {
          name: 'My new company to replace old company!'
        }.to_json, {
          'X-Auth-Token' => token.string,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
        
        expect(response.status).to eq(403)
        expect(Company.count).to eq(1);
      end
    end
  end
end
