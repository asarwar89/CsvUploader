Rails.application.routes.draw do
  get 'welcome/index'

  # get 'read_files/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :articles
  resources :read_files
  resources :countries
  resources :persons

  delete 'persons', to: 'persons#destroyAll'

  root 'persons#index'
end
