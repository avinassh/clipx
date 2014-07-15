require "resque_web"
Rails.application.routes.draw do
  # Home Page
  root to: 'visitors#index'

  # Article-related
  resources :articles

  # Devise auto-generates routes for various authentication-related methods
  # see `rake routes` for more details
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'users/sign_out', :to => 'devise/sessions#destroy'
  end

  # Resque Web-UI
  is_admin = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  # TODO: Shift to a controller for authentication (resque)
  # Current solution gives a 404 as route doesn't get defined
  # http://stackoverflow.com/a/7284523/368328
  constraints is_admin do
    mount ResqueWeb::Engine, :at => "/resque"
  end
end