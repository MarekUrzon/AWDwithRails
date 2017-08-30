Rails.application.routes.draw do
	root 'store#index',as: 'store/index'

	resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
