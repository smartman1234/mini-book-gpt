Rails.application.routes.draw do
  post '/ask', to: 'questions#ask'
  get '/question/:id', to: 'pages#home'
  
  root 'pages#home'
end
