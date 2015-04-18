require 'rails_helper'

RSpec.describe 'Listing projects', type: :request do
	let(:user) {FactoryGirl.create(:user_with_company)}
	let(:company) {user.companies.last}
	let(:company_two) {FactoryGirl.create(:company)}
	let(:unauthorized_company) {FactoryGirl.create(:company)};
	let(:token) {FactoryGirl.create(:token, user: user)}

	before do 
		company_two.users << user
		10.times {FactoryGirl.create(:project, company: company)}
		10.times {FactoryGirl.create(:project, company: company_two)}
		10.times {FactoryGirl.create(:project, company: unauthorized_company)}
	end

	context 'with a company id' do
		it 'returns a 200' do
			get '/api/projects', {
				company_id: company.id
			}, {
				'Accept' => 'application/json',
				'Content-Type' => 'application/json',
				'X-Auth-Token' => token.string
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			projects = json(response.body)[:projects]
			expect(projects.count).to eq(10)
			expect(projects.last[:company_id]).to eq(company.id)
		end
	end

	context 'with no company id' do
		it 'returns a 200' do
			get '/api/projects', nil, {
				'Accept' => 'application/json',
				'Content-Type' => 'application/json',
				'X-Auth-Token' => token.string
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			projects = json(response.body)[:projects]
			expect(projects.count).to eq(20)
		end
	end

	context 'with unauthorized company id' do
		it 'returns a 200' do
			get '/api/projects', {
				company_id: unauthorized_company.id
			}, {
				'Accept' => 'application/json',
				'Content-Type' => 'application/json',
				'X-Auth-Token' => token.string
			}

			expect(response.status).to eq(403)
			expect(response.content_type).to eq(Mime::JSON)
		end
	end

	context 'with invalid credentials' do
		it 'returns a 200' do
			get '/api/projects', {
				company_id: unauthorized_company.id
			}, {
				'Accept' => 'application/json',
				'Content-Type' => 'application/json',
			}

			expect(response.status).to eq(401)
			expect(response.content_type).to eq(Mime::JSON)
		end
	end


end
