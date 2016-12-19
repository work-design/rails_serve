Rails.application.routes.draw do

  namespace :admin do
    resources :whos
    resources :roles do
      patch 'toggle/:rule_id' => :toggle, on: :member, as: :toggle
      get :whos, on: :member
      delete 'who/:who_id' => :delete_who, on: :member, as: :who
    end
    resources :sections do
      patch 'move_lower', on: :member
      patch 'move_higher', on: :member
      resources :rules do
        patch 'sync', on: :collection
        patch 'move_lower', on: :member
        patch 'move_higher', on: :member
        get 'roles', on: :member
      end
    end
  end


end

