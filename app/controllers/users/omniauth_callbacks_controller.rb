class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def pocket
   current_user.add_pocket_account request.env['omniauth.auth']
   set_flash_message(:notice, :success, :kind => "Pocket")
   redirect_to '/'
  end

  def evernote
    #render json: request.env['omniauth.auth']
    current_user.add_evernote_account request.env['omniauth.auth']
    set_flash_message(:notice, :success, :kind => "Evernote")
    redirect_to '/'
  end

end