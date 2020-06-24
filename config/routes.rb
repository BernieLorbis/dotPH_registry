Rails.application.routes.draw do
  	
	get 'users/login'
	get 'users/logout'
	get 'users/create'
	get 'users/destroy'

  	root 'domains#index'
	resources :domains

	get 'search/', to: 'domains#index'
	post 'login/', to: 'users#login'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
