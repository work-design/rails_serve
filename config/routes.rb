Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace :serve, defaults: { business: 'serve' } do
      resources :services do
        resources :servers
      end
      resources :servings do
        member do
          get :qrcode
        end
      end
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
        resources :services do
          member do
            get :wallet
            patch :update_wallet
          end
          resources :servers
        end
      end
      namespace :my, defaults: { namespace: 'my' } do
        resources :items, only: [] do
          resources :servings
        end
      end
      namespace :me, defaults: { namespace: 'me' } do
        resources :servings do
          member do
            get :qrcode
            patch :start
            patch :finish
          end
        end
      end
    end
  end
  resolve 'Serve::Service' do |service, options|
    [:serve, service, options]
  end
end
