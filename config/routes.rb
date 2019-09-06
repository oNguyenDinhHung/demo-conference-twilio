Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/verify_access_code', to: 'home#verify_access_code'
  get '/join_conference', to: 'home#join_conference'
  post '/status_callback', to: 'home#status_callback'
end
