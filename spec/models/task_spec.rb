require 'rails_helper'

RSpec.describe Task, :type => :model do
  let(:task) {FactoryGirl.create(:task)}

  it 'is invalid without a taskable' do
    task.taskable = nil
    expect(task).to be_invalid
  end
end
