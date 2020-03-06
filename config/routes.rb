Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, only: :show
	root 'chess#index'
	get 'games/:id/forfeit', :to => 'games#forfeit', :as => "forfeit"
   resources :games do
    get :castle_kingside, to: 'pieces#castle_kingside'
    get :castle_queenside, to: 'pieces#castle_queenside'
  end 

  resources :pieces, only: %i[show update] do 
    get :reload
  end

  resources :games

  mount ActionCable.server, at: '/cable'
end
