require 'rails_helper'

RSpec.describe 'Items API' do
  it 'returns a list of items' do
    create_list(:item, 3)

    get '/api/v1/items'
    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
    # binding.pry
    expect(items.count).to eq(3)
    #
    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'returns a single item' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(item.class).to eq(Hash)

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes][:unit_price]).to be_a(Float)

  end

  it 'returns a single merchant - sad path' do
    id = create(:item).id
    create_list(:item, 2)
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(Item.all.count).to eq(3)

    expect(item[:attributes][:name]).to_not eq(Item.second.name)
    expect(item[:attributes][:name]).to_not eq(Item.last.name)
  end

end
