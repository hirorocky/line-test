Rails.application.routes.draw do
  resources :users
  resources :companies
  resources :posts
  root 'pages#show'
  get 'pages/show'
  post '/callback' => 'line_events#callback'
end
