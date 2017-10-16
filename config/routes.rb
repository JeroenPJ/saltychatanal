Rails.application.routes.draw do
  get 'result', to: 'pages#result', as: 'result'

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
