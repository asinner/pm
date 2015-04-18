require 'rails_helper'

RSpec.describe 'Listing discussions', type: :request do
	let(:user) {FactoryGirl.create(:user_with_company)}
	let(:company) {user.companies.last}
	let(:token) {FactoryGirl.create(:token, user: user)}
	let(:project) {FactoryGirl.create(:project_with_discussions, company: company)}
	let(:unauthorized_project) {FactoryGirl.create(:project)}

	context 'with valid information' do
		it 'returns a 201' do
			get '/api/discussions', {
				project_id: project.id
			}, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			discussions = json(response.body)[:discussions]
			expect(discussions.count).to eq(5)
		end
	end

	context 'with invalid credentials' do
		it 'returns a 401' do
			get '/api/discussions', {
				project_id: project.id
			}, {
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(401)
			expect(response.content_type).to eq(Mime::JSON)
		end
	end

	context 'for an unauthorized project' do
		it 'returns a 403' do
			get '/api/discussions', {
				project_id: unauthorized_project.id
			}, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(403)
			expect(response.content_type).to eq(Mime::JSON)
		end
	end

	context 'with an inactive company' do

		before {company.update(subscription_status: 'cancel')}

		it 'returns a 402' do

			get '/api/discussions', {
				project_id: project.id
			}, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(402)
			expect(response.content_type).to eq(Mime::JSON)
		end
	end
end
