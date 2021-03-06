require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'returns a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'
    #this will automatically create a response object

    # post '/api/v1/books', params: { book: book_params }, as: :json

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]
    expect(merchants.count).to eq(3)
    # binding.pry

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it 'returns a single merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    expect(merchant.class).to eq(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_an(String)

  end

  it 'returns a single merchant - sad path' do
    id = create(:merchant).id
    create_list(:merchant, 2)
    get "/api/v1/merchants/99999999"

    expect(response).to_not be_successful

  end

  it 'returns a single merchant - sad path v2 ' do
    id = create(:merchant).id
    create_list(:merchant, 2)
    get "/api/v1/merchants/string_instead_of_integer"

    expect(response).to_not be_successful

  end

  it 'returns a single merchant - edge case' do
    id = create(:merchant).id
    create_list(:merchant, 2)
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    expect(Merchant.all.count).to eq(3)

    expect(merchant[:attributes][:name]).to_not eq(Merchant.second.name)
    expect(merchant[:attributes][:name]).to_not eq(Merchant.last.name)
  end

  it 'returns a merchants items' do
    id = create(:merchant).id
    create_list(:item, 3, merchant_id: id)


    get "/api/v1/merchants/#{id}/items"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    # binding.pry
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

  it 'returns a merchants items - sad path' do
    id = create(:merchant).id
    create_list(:item, 3, merchant_id: id)

    id_2 = create(:merchant).id
    other_item = create_list(:item, 1, merchant_id: id_2)


    get "/api/v1/merchants/#{id}/items"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    items.each do |item|
      expect(item[:attributes][:name]).to_not eq(other_item.first.name)
    end

  end

  it 'returns a single merchant given a search param' do
    merchant1 = create(:merchant, name: "Jim")
    merchant2 = create(:merchant, name: "Jam Board")
    merchant3 = create(:merchant, name: "NickT")
    # create_list(:merchant, 2)

    get "/api/v1/merchants/find?name=J"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    expect(merchant.class).to eq(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_an(String)

    expect(merchant[:attributes][:name]).to eq("Jim")

  end

  it 'returns a single merchant given a search param - sad path' do
    merchant1 = create(:merchant, name: "Jim")
    merchant2 = create(:merchant, name: "Jam Board")
    merchant3 = create(:merchant, name: "NickT")

    get "/api/v1/merchants/find?name="

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body[:data][:errors]).to eq("Search cannot be blank.")


  end

  it 'returns a single merchant given a search param - sad path #2' do
    merchant1 = create(:merchant, name: "Jim")
    merchant2 = create(:merchant, name: "Jam Board")
    merchant3 = create(:merchant, name: "NickT")

    get "/api/v1/merchants/find?name=alphabet"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body[:data][:errors]).to eq('No merchant with this search was found.')


  end

end
