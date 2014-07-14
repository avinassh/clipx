require "resque_web"
Rails.application.routes.draw do
  # Home Page
  root to: 'visitors#index'

  # Article-related
  resources :articles
  get 'article/:id/publish/:provider' => 'article#publish'

  # Devise auto-generates routes for various authentication-related methods
  # see `rake routes` for more details
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'users/sign_out', :to => 'devise/sessions#destroy'
  end

  # Resque Web-UI
  mount ResqueWeb::Engine => "/resque"
end