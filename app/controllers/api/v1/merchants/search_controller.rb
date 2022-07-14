module Api
  module V1
    module Merchants
      class SearchController < ApplicationController

        def find
          if params[:name] == ""
            render json: { data: { errors: 'Search cannot be blank.' } }
          else
            merchant = Merchant.search(params[:name])
            if merchant != nil
              render json: MerchantSerializer.new(merchant)
            else
              render json: { data: { errors: 'No merchant with this search was found.' } }
            end
          end
        end

      end
    end
  end
end
