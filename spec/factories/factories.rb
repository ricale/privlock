# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :writing, class: Writing do
    sequence(:title) { |i| "Sample#{i}" }
    content "this is sample"
    association :category
    association :user
  end

  factory :category, class: Category do
    name "sample"
  end

  factory :user, class: User do
    sequence(:email) { |i| "admin#{i}@test.com" }
    password "password"
    name "name"
    admin true
  end

  factory :normal_user, class: User do
    sequence(:email) { |i| "tester#{i}@test.com" }
    password "password"
    name "name"
  end

  factory :comment, class: Comment do
    association :writing
    email "tester@test.com"
    name "name"
    password_hash "password"
    association :user
    content "sample content"
  end

  factory :setting, class: Setting do
    active true
    title "sample"
    number_of_writing 10
  end
end
