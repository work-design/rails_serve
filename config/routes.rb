Rails.application.routes.draw do

  scope :admin, as: 'admin', module: 'the_role_admin' do
    scope path: ':who_type/:who_id' do
      resources :who_roles
    end
    resources :roles do
      get :overview, on: :member
    end
    resources :governs do
      post :sync, on: :collection
      patch :move_lower, on: :member
      patch :move_higher, on: :member
      resources :rules do
        patch :sync, on: :collection
        patch :move_lower, on: :member
        patch :move_higher, on: :member
        get :roles, on: :member
      end
    end
    resources :govern_taxons
  end


end

