Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'users/sign_out', :to => 'devise/sessions#destroy'
  end
  get 'article/:id/publish/:provider' => 'article#publish'
end