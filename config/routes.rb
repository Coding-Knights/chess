Rails.application.routes.draw do
  devise_for :models
# Needed to get devise installation complete(Al Trujillo)
#Ensure you have defined root_url to *something* in your config/routes.rb.
#     For example:
#       root to: "home#index"
end
