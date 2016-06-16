Rails.application.routes.draw do

  namespace :admin do
    resources :roles do
      patch 'toggle/:rule_id' => :toggle, on: :member, as: :toggle
      get :users, on: :member
      delete 'user/:user_id' => :delete_user, on: :member, as: :user
    end
    resources :sections do
      patch 'move_lower', on: :member
      patch 'move_higher', on: :member
      resources :rules do
        patch 'move_lower', on: :member
        patch 'move_higher', on: :member
      end
    end
  end


end

