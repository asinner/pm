FactoryGirl.define do
  factory :project do
    name 'Internal feature'
    description 'A project that builds out a feature'
    company
    
    factory :project_with_tasks do
      after(:create) do |project| 
        project.tasks << FactoryGirl.create(:task)
      end
    end
  end
end