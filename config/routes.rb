Rails.application.routes.draw do
  resources :tweets
  resources :feeds do 
    resources :tweets
  end
  resources :users

  get '/data', to: "tweets#get_data"
  get '/feeds/:id/refresh', to: "feeds#refresh_tweets"
  root 'feeds#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
