FactoryBot.define do
    factory :item do
      association :merchant
      name { Faker::Book.title }
      description { Faker::TvShows::DumbAndDumber.quote }
      unit_price {Faker::Number.between(from: 0.0, to: 500.0).round(2)}
    end
  end
