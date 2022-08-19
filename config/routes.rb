Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace :serve, defaults: { business: 'serve' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
        resources :services do
          resources :servers
        end
      end
    end
  end
end
