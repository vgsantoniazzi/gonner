Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get    '*resource_name/:id', to: 'base#show'
      put    '*resource_name/:id', to: 'base#update'
      delete '*resource_name/:id', to: 'base#destroy'
      get    '*resource_name',     to: 'base#index'
      post   '*resource_name',     to: 'base#create'
    end
  end
end
