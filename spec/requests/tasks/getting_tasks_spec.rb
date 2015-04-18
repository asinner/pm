require 'rails_helper'

RSpec.describe 'Getting tasks', type: :request do
	let(:user) {FactoryGirl.create(:user_with_company)}
	let(:company) {user.companies.last}
	let(:token) {FactoryGirl.create(:token, user: user)}
	let(:project) {FactoryGirl.create(:project, company: company)}
	let(:different_project) {FactoryGirl.create(:project, company: company)}
	let(:unauthorized_project) {FactoryGirl.create(:project)}

	before do
		10.times do
			project.tasks << FactoryGirl.create(:task)
		end
	end

	before do
		23.times do
			different_project.tasks << FactoryGirl.create(:task)
		end
	end

	context 'with valid information' do
		it 'returns a 200' do
			expect(project.tasks.count).to eq(10)

			get '/api/tasks', {
				project_id: project.id
			}, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			tasks = json(response.body)[:tasks]
			expect(tasks.count).to eq(10)
		end
	end

	context 'with invalid credentials' do
		it 'returns a 401' do
			expect(project.tasks.count).to eq(10)

			get '/api/tasks', {
				project_id: project.id
			}, {
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(401)
			expect(response.content_type).to eq(Mime::JSON)
		end
	end

	context 'with unauthorized project' do
		it 'returns a 403' do
			expect(project.tasks.count).to eq(10)

			get '/api/tasks', {
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
end
