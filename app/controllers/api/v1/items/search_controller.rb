module Api
  module V1
    module Items
      class SearchController < ApplicationController

        def find_all
          # binding.pry
          if params[:name] == ""
            render json: { data: { errors: 'Search cannot be blank.' } }
          else
            items = Item.search_all(params[:name])
            if items != []
              render json: ItemSerializer.new(items)
            else
              render json: { data: [] }
            end
          end
        end

      end
    end
  end
end
