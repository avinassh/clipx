class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def pocket
   current_user.add_account 'pocket', request.env['omniauth.auth']
   set_flash_message(:notice, :success, :kind => "Pocket")
   redirect_to '/'
  end

  def evernote
    current_user.add_evernote_account request.env['omniauth.auth']
    set_flash_message(:notice, :success, :kind => "Evernote")
    redirect_to '/'
  end

end