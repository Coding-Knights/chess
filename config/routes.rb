Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	  root 'chess#index'

	  resources :pawns
	  resources :knights
	  resources :bishops
	  resources :rooks
	  resources :queens
	  resources :kings

end
