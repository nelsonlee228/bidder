# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bid do
    association :listing, factory: :listing
    association :user, factory: :user
    prices Faker::Number.number(3)
  end
end
