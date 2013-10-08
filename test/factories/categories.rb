# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "MyString"
    parent_id "MyString"
    depth 1
    order_in_parent 1
  end
end
