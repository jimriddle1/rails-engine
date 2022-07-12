class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  has_many :items
  # binding.pry
end
