Rails.application.routes.draw do
  scope '/', defaults: { format: :json } do
    namespace :api do
      namespace :v1, defaults: { format: :json } do
        resources :records
        resources :artists
      end
    end

    root to: 'home#index'

    post 'refresh', controller: :refresh, action: :create
    post 'signin', controller: :signin, action: :create
    post 'signup', controller: :signup, action: :create

    delete 'signin', controller: :signin, action: :destroy
  end
end
