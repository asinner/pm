require 'rails_helper'

RSpec.describe PagesController, :type => :controller do
  describe "GET #home" do
    it 'responds with a 200' do
      get :home
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
