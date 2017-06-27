Rails.application.routes.draw do
  
  get 'admins/index'
  get 'entries/scraping'

  root 'entries#index'
  resources :categories
  resources :entries
  resources :authors
end
