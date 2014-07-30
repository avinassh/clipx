class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Instead of defining multiple methods for
  # every provider, we just use this
  def action_missing(provider)
    current_user.add_account provider, request.env['omniauth.auth']
    flash[:notice] = "#{provider.titlecase} was successfully integrated."
    redirect_to '/'
  end
end