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
    create_list(:merchant, 2)
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful


    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    # binding.pry
    expect(merchant.class).to eq(Hash)
    expect(Merchant.all.count).to eq(3)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_an(String)

    expect(merchant[:attributes][:name]).to_not eq(Merchant.second.name)
    expect(merchant[:attributes][:name]).to_not eq(Merchant.last.name)
    # get '/api/v1/merchants'
  end

  it 'returns a merchants items' do
    # id = create(:merchant).id
    # create_list(:item, 4, merchant_id: id)

    id = create(:merchant).id
    items = create_list(:item, 3, merchant_id: id)
    # binding.pry
    get "/api/v1/merchants/#{id}/items"

    expect(response).to be_successful



  end

end
