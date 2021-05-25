Rails.application.routes.draw do

  namespace 'roled', defaults: { business: 'roled' } do
    namespace :panel, defaults: { namespace: 'panel' } do
      resources :roles do
        member do
          post :overview
          post :namespaces
          post :governs
          post :rules
          patch :business_on
          patch :business_off
          patch :namespace_on
          patch :namespace_off
          patch :govern_on
          patch :govern_off
          patch :rule_on
          patch :rule_off
        end
        resources :who_roles, only: [:index, :new, :create, :destroy]
        resources :role_rules, except: [:destroy] do
          collection do
            post :disable
            delete '' => :destroy
          end
        end
      end
      resources :governs, only: [:index] do
        collection do
          post :sync
          post :namespaces
          post :governs
          post :rules
        end
        member do
          patch :move_lower
          patch :move_higher
        end
        resources :rules do
          member do
            patch :move_lower
            patch :move_higher
            get :roles
          end
        end
      end
      resources :name_spaces do
        collection do
          post :sync
        end
        member do
          patch :move_lower
          patch :move_higher
        end
      end
      resources :busynesses do
        collection do
          post :sync
        end
        member do
          patch :move_lower
          patch :move_higher
        end
      end
    end

    namespace :admin, defaults: { namespace: 'admin' } do
      scope path: ':who_type/:who_id' do
        resource :who_roles, only: [:show, :edit, :update]
      end
    end
  end

end

