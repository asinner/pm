require 'rails_helper'

RSpec.describe 'Completing a task' do
	let(:user) {FactoryGirl.create(:user_with_company)}
	let(:token) {FactoryGirl.create(:token, user: user)}
	let(:company) {user.companies.last}
	let(:project) {FactoryGirl.create(:project_with_tasks, company: company)}
	let(:task) {project.tasks.last}

	context 'with valid information' do
		it 'shows who completed it and at what time' do
			put "/api/tasks/#{task.id}", {
				completed: true
			}.to_json, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			task = json(response.body)[:task]
			expect(task[:completor][:id]).to eq(user.id)
			expect(task[:completed]).to be(true)
		end
	end

	context 'with valid information' do
		it 'shows who uncompleted it and at what time' do
			put "/api/tasks/#{task.id}", {
				completed: false
			}.to_json, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			task = json(response.body)[:task]
			expect(task[:uncompletor_id]).to eq(user.id)
			expect(task[:completed]).to be(false)
		end
	end
end
