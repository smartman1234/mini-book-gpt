Rails.application.routes.draw do
  get '/ask', to: 'questions#ask'
  
  root 'pages#home'
end
