Rails.application.routes.draw do

  devise_for :users
	  root 'chess#index'

	  resources :pawns
	  resources :knights
	  resources :bishops
	  resources :rooks
	  resources :queens
	  resources :kings

end
