# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invalid_writing, class: Writing do

    factory :no_title do
      content     "this is just test"
      association :category
    end

    factory :no_content do
      title       "test"
      association :category
    end

    factory :no_category_id do
      title   "test"
      content "this is just test"
    end

    factory :invalid_category_id do
      title       "test"
      content     "this is just test"
      category_id 0
    end

  end

  factory :writing, class: Writing do
    sequence(:title) { |i| "Sample#{i}" }
    content "this is sample"
    association :category
  end
end
