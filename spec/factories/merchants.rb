FactoryBot.define do
    factory :merchant do
      name { Faker::Book.author }
      # after(:build) do |instance|
      #   # binding.pry
      #   3.times { instance.items << FactoryBot.create(:item) }
      # end
    end
  end
