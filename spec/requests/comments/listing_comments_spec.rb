require 'rails_helper'

RSpec.describe 'Listing comments' do
	let(:user) {FactoryGirl.create(:user_with_company)}
	let(:token) {FactoryGirl.create(:token, user: user)}
	let(:company) {user.companies.last}
	let(:project) {FactoryGirl.create(:project_with_discussions, company: company)}
	let(:discussion) {project.discussions.last}
	let(:unauthorized_discussion) {FactoryGirl.create(:discussion)}

	before do
		10.times do
			FactoryGirl.create(:comment, commentable: discussion)
		end
	end

	context 'for a discussion with valid information' do
		it 'returns a 200' do
			get '/api/comments', {
				discussion_id: discussion.id
			}, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(200)
			expect(response.content_type).to eq(Mime::JSON)
			comments = json(response.body)[:comments]
			expect(comments.size).to eq(10)
		end
	end

	context 'for a discussion with invalid information' do
		it 'returns a 404' do
			expect {
				get '/api/comments', {
					discussion_id: 0
				}, {
					'X-Auth-Token' => token.string,
					'Accept' => 'application/json',
					'Content-Type' => 'application/json'
				}
			}.to raise_error(ActiveRecord::RecordNotFound)
		end
	end

	context 'for an unauthorized discussion' do
		it 'returns a 403' do
			get '/api/comments', {
				discussion_id: unauthorized_discussion.id
			}, {
				'X-Auth-Token' => token.string,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}

			expect(response.status).to eq(403)
			expect(response.content_type).to eq(Mime::JSON)			
		end
	end

	context 'with an invalid subscription' do
		before do
			company.update(subscription_status: 'cancel')
		end

		it 'returns a 402' do
			get '/api/comments', {
				discussion_id: discussion.id
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
