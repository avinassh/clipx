require "resque_web"
# Workaround as per https://github.com/resque/resque-web/issues/29
ResqueWeb::Engine.eager_load!
Rails.application.routes.draw do
  # Home Page
  root to: 'visitors#index'

  # Article-related
  get 'articles/:id/print', :to => 'articles#print'
  resources :articles

  # Devise auto-generates routes for various authentication-related methods
  # see `rake routes` for more details
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'users/sign_out', :to => 'devise/sessions#destroy'
    get 'users/auth/failure', :to => 'users#omniauth_failure'
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