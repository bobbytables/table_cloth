FactoryGirl.define do
  factory :dummy_model do
    sequence(:id) { |n| n }
    email "robert@example.com"
    name  "robert"
  end
end