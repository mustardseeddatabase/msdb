Msdb::Application.routes.draw do
  resources :limit_categories do
    put 'update', :on => :collection
  end
  resources :inventories
  resources :distributions
  resources :donors do
    resources :donations
  end
  resources :donations
  resources :admin
  match '/items/autocomplete', :to => 'items#autocomplete'
  match '/items/:upc', :to => 'items#show', :via => :get
  match '/items/:upc', :to => 'items#update', :via => :put
  match '/items/show', :to => 'items#show', :via => :get
  match '/items/update_all/:inventory_id', :to => 'items#update_all', :via => :put, :as => :update_all_items
  resources :qualification_documents do
    put 'update', :on => :collection
  end

  resources :clients do
    get 'autocomplete', :on => :collection
    resources :distributions
  end

  resources :items do
    get 'autocomplete', :on => :collection
  end

  resources :addresses do
    get 'autocomplete', :on => :collection
  end

  resources :households do
    get 'autocomplete', :on => :collection
    resources :household_clients
    resources :clients
  end

  resources :scanner

  # this route is specified as it's used in authengine as the place
  # where logged-in users first land
  #match 'home', :to => 'households#index'
  match 'home', :to => 'home#index'
end
