Rails.application.routes.draw do

  devise_for :users
	  root 'chess#index'
end
