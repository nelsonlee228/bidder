FactoryGirl.define do
  factory :listing do
    association :user, factory: :user
    sequence(:title) {|n| "#{Faker::Company.bs} #{n}" }
    sequence(:detail) {|n| "#{Faker::Lorem.paragraph} #{n}" }
    end_on Faker::Business.credit_card_expiry_date
    reserve_price Faker::Number.number(3)
  end
end
