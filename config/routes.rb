Msdb::Application.routes.draw do
  resources :limit_categories do
    put 'update', :on => :collection
  end
  #namespace :reports do
    #resource :second_harvest_report, :only => :show
  #end
  resources :reports, :only => :index
  resources :inventories
  resources :distributions
  resource :sku_list
  resources :sku_list_items
  resources :donors do
    resources :donations
  end
  resources :donations
  resources :admin
  # TODO the following route should update an inventory model, which will update constituent items
  match '/items/update_all/:inventory_id', :to => 'items#update_all', :via => :put, :as => :update_all_items

  resources :clients do
    get 'autocomplete', :on => :collection
    resources :distributions
    resources :checkins do
      post 'update_and_show_client' # would normally be 'put', but post is much easier to implement!
    end
    resources :qualification_documents
  end

  resources :qualification_documents

  resource :checkins do
    get 'new'
  end
  resources :checkins do
    resources :clients
    resources :households
    resources :qualification_documents
  end

  resources :items # for actions for which it's not known if the item has a sku or upc
  match '/upc_items/:upc', :to => 'upc_items#show', :via => :get, :as => :upc_item # for the upc_items controller, we use the upc as a reference
  resources :upc_items, :except => :show
  resources :sku_items do
    get 'autocomplete', :on => :collection
  end

  resources :addresses do
    get 'autocomplete', :on => :collection
  end

  resources :households do
    get 'autocomplete', :on => :collection
    resources :household_clients
    resources :clients
    resources :checkins do
      post 'update_and_show_household'
    end
  end

  resources :scanner

  # this route is specified as it's used in authengine as the place
  # where logged-in users first land
  match 'home', :to => 'home#index'
end
