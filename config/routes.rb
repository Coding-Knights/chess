Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, only: :show
	root 'chess#index'
	get 'games/:id/forfeit', :to => 'games#forfeit', :as => "forfeit"
  

  resources :pieces, only: %i[show update] do 
    get :castle
    get :reload
  end

  resources :games

end
