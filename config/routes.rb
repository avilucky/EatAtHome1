Rails.application.routes.draw do
  
 
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  resources :food_images
  resources :user_images
  root :controller => 'static', :action => :home
  #resources :orders
  resources :users do
    resources :user_images
    member do
    get :follow
    get :unfollow
  end
  end
  
  # for mapping the common 8 methods to the respective uris
  resources :food_items do
    resources :food_images
    resources :food_reviews
  end
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  match '/login', to:'sessions#login', via: :post
  match '/signup', to:'sessions#signup', via: :post
  match '/logout', to: 'sessions#destroy', via: :delete
  match '/login_form', to: 'sessions#login_form', via: :get
  match '/signup_form', to: 'sessions#signup_form', via: :get
  match '/signup_confirm', to: 'sessions#signup_confirm', via: :get
  match '/update_form', to: 'users#update_form', via: :get
  
  match '/orders/order', to: 'orders#order', via: :post, as: :place_order
  match '/orders/:id', to: 'orders#show', via: :get, as: :order
  match '/orders/status/:id', to: 'orders#change_status', via: :post, as: :change_status
  match '/food_items/:id/availability_update', to: 'food_items#update_availability_only', via: :put, as: :food_items_availability_update
end
