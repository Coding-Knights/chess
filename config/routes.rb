Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	root 'chess#index'
   resources :games do
    get 'games/:id/forfeit', :to => 'games#forfeit', :as => "forfeit"
    get :castle_kingside, to: 'pieces#castle_kingside'
    get :castle_queenside, to: 'pieces#castle_queenside'
  end 

  resources :pieces, only: %i[show update] do 
    get :reload
  end

  resources :games

  mount ActionCable.server, at: '/cable'
end
