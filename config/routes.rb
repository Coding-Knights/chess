Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	root 'chess#index'
  resources :games
  get 'games/:id/forfeit', :to => 'games#forfeit', :as => "forfeit"
  resources :pieces, only: %i[show update] do 
    get :reload
  end

  mount ActionCable.server, at: '/cable'
end
