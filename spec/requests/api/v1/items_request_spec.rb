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

  it 'returns a single item - sad path' do
    id = create(:item).id
    create_list(:item, 2)
    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(Item.all.count).to eq(3)

    expect(item[:attributes][:name]).to_not eq(Item.second.name)
    expect(item[:attributes][:name]).to_not eq(Item.last.name)
  end

  it 'can create a new item' do
    id = create(:merchant).id
    item_params = {
      name: 'sunscreen',
      description: 'pretty good sunscreen',
      unit_price: 25.0,
      merchant_id: id

      }
      #why were we able to create items with no merchants in above tests

     post '/api/v1/items', params: { item: item_params }, as: :json
     expect(response).to be_successful

     created_item = Item.last
     expect(created_item).to be_a(Item)
     expect(created_item.name).to be_a(String)
     expect(created_item.description).to be_a(String)
     expect(created_item.unit_price).to be_a(Float)
     expect(created_item.merchant_id).to be_a(Integer)
  end

  it 'can delete a new item' do
    item = create(:item)
    expect(Item.all.count).to eq(1)
    delete "/api/v1/items/#{item.id}"
    expect(response).to be_successful

    expect(Item.all.count).to eq(0)
  end

  it 'can upadte a new item' do
    id = create(:item).id
    current_desc = Item.first.description
    item_params = {
      description: 'pretty good sunscreen'
      }
    patch "/api/v1/items/#{id}", params: { item: item_params }, as: :json
    expect(response).to be_successful

    expect(Item.first.description).to eq("pretty good sunscreen")
    expect(Item.first.description).to_not eq(current_desc)
  end

  it 'can update a new item - sad path' do
    id = create(:item).id

    item_params = {
      name: 'sunscreen',
      description: 'pretty good sunscreen',
      unit_price: 25.0,
      merchant_id: 9999999999
      }
    patch "/api/v1/items/#{id}", params: { item: item_params }, as: :json
    expect(response).to_not be_successful
  end

  it 'can find a merchant of a new item - happy and sad' do
    id = create(:merchant).id
    item = create_list(:item, 1, merchant_id: id)
    create_list(:merchant, 2)

    get "/api/v1/items/#{item.first.id}/merchant"
    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant[:attributes][:name]).to be_a(String)

    expect(merchant[:attributes][:name]).to_not eq(Merchant.second.name)
    expect(merchant[:attributes][:name]).to_not eq(Merchant.last.name)
  end

  it 'can find all matching items' do

    item1 = create(:item, name: "Sunscreen")
    item2 = create(:item, name: "Better Sunscreen")
    item3 = create(:item, name: "Octopus Squishy")

    get "/api/v1/items/find_all?name=sun"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
    expect(items.class).to eq(Array)

    expect(items.first).to have_key(:id)
    expect(items.first[:id]).to be_an(String)

    expect(items.first).to have_key(:attributes)
    expect(items.first[:attributes][:name]).to be_an(String)

    expect(items.first).to have_key(:attributes)
    expect(items.first[:attributes][:description]).to be_an(String)

    expect(items.first).to have_key(:attributes)
    expect(items.first[:attributes][:unit_price]).to be_an(Float)

    expect(items.first[:attributes][:name]).to eq("Sunscreen")

  end

end
