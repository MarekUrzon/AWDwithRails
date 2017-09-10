Rails.application.routes.draw do
  resources :users
	resources :orders
	resources :carts
	resources :line_items
	resources :cards
	root 'store#index',as: 'store/index'

	resources :products do
		get :who_bought, on: :member
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
