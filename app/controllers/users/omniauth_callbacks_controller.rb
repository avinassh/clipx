class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def pocket
    current_user.add_pocket_account request.env['omniauth.auth']
    #TODO: Add flash message for successful integration
    redirect_to '/'
  end
end