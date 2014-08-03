class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Instead of defining multiple methods for
  # every provider, we just use this
  def dropbox
    render json: request.env['omniauth.auth']
  end
  def action_missing(provider)
    account = current_user.add_account provider, request.env['omniauth.auth']
    if account.is_a? PublisherAccount
      Resque.enqueue ExportJob, current_user.id, account.class.name
    end
    flash[:notice] = "#{provider.titlecase} was successfully integrated."
    current_user
    redirect_to '/'
  end
end