Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/v1/items/:id/merchant', to: 'api/v1/merchant_items#show'
  #can we use resources to not have to handroll this route?
  get '/api/v1/merchants/find', to: 'api/v1/merchants/search#find'
  get '/api/v1/items/find_all', to: 'api/v1/items/search#find_all'

  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
    end
  end

end
