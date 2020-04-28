Rails.application.routes.draw do
  root 'pages#show'
  get 'pages/show'
  post :line_events, to: 'line_events#recieve'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
