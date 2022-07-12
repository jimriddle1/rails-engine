require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'returns a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'
    #this will automatically create a response object

    # post '/api/v1/books', params: { book: book_params }, as: :json

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(3)
    # binding.pry

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)

    end


  end

end
