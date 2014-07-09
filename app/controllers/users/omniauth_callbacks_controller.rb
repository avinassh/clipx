class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def pocket
    current_user.add_pocket_token request.env['omniauth.auth'].credentials.token
    redirect_to '/'
  end
end