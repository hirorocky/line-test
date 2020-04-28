Rails.application.routes.draw do
  resources :posts
  root 'pages#show'
  get 'pages/show'
  post '/callback' => 'line_events#callback'
  post '/line_events' => 'line_events#recieve'
end
