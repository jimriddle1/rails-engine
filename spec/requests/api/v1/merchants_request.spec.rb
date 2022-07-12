require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'returns a list of merchants' do
    create_list(:merchants, 3)

    get '/api/v1/merchants'
    #this will automatically create a response object

    # post '/api/v1/books', params: { book: book_params }, as: :json

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(3)

    merchants.each do |book|
      # expect(book).to have_key(:id)
      # expect(book[:id]).to be_an(Integer)
      #
      # expect(book).to have_key(:title)
      # expect(book[:title]).to be_a(String)
      #
      # expect(book).to have_key(:author)
      # expect(book[:author]).to be_a(String)
      #
      # expect(book).to have_key(:genre)
      # expect(book[:genre]).to be_a(String)
      #
      # expect(book).to have_key(:summary)
      # expect(book[:summary]).to be_a(String)
      #
      # expect(book).to have_key(:number_sold)
      # expect(book[:number_sold]).to be_an(Integer)
    end


  end

end
