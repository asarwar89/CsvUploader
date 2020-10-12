Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'persons/index'
      post 'persons/create'
      delete 'persons', to: 'persons#destroyAll'
    end
  end

  get 'upload', to: 'persons#index'

  root 'persons#index'

end
