Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'persons/index'
      post 'persons/create'
      delete 'persons', to: 'persons#destroyAll'
    end
  end

  root 'persons#index'

end
