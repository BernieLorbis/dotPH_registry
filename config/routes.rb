Rails.application.routes.draw do
  	
  	devise_for :users

	get 'users/login'
	get 'users/logout'
	get 'users/create'
	get 'users/destroy'

  	root 'domains#index'
	resources :domains

	get 'search/', to: 'domains#index'
	# Login
	post 'login/', to: 'users#login'

	# User Registration
	post 'register/', to: 'users#register'


	# Validate session
	post '/validateSession', to: 'users#validate_session'

	# Paypal Integration
	get 'payment', to: 'users#payment' # payment page
	post 'payment/create', to: 'payments#create' # create payment
	post 'payment/execute', to: 'payments#execute' # create payment


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
