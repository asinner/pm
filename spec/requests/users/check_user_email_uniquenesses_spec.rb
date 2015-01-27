require 'rails_helper'

RSpec.describe "User", :type => :request do
  let(:user) { FactoryGirl.create(:user, email: 'andrew@example.com') }
  describe 'check email uniqueness' do
    it "returns 204 if an email is found" do
      get "/api/users/email?email=#{user.email}"
      expect(response.status).to eq(204)
    end
    
    it "returns 404 if no email is found" do
      get "/api/users/email?email=not-taken@example.com"
      expect(response.status).to eq(404)
    end
  end
end
