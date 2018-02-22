Rails.application.routes.draw do

  namespace :admin do
    resources :whos
    resources :roles
    resources :governs do
      patch 'move_lower', on: :member
      patch 'move_higher', on: :member
      resources :rules do
        patch 'sync', on: :collection
        patch 'move_lower', on: :member
        patch 'move_higher', on: :member
        get 'roles', on: :member
      end
    end
    resources :govern_taxons
  end


end

