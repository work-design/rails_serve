Rails.application.routes.draw do

  namespace :admin do
    resources :roles do
      patch 'toggle/:rule_id' => :toggle, on: :member, as: :toggle
      get :users, on: :member
      delete 'user/:user_id' => :delete_user, on: :member, as: :user
    end
    resources :sections do
      resources :rules
    end
  end


end

