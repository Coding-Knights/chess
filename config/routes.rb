Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	root 'chess#index'
  resources :games
  get 'games/:id/forfeit', :to => 'games#forfeit', :as => "forfeit"
  resources :pieces
end
