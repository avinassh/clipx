class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Instead of defining multiple methods for
  # every provider, we just use this
  def action_missing(provider)
    account = current_user.add_account provider, request.env['omniauth.auth']
    if account.is_a? PublisherAccount
      Resque.enqueue ExportJob, current_user.id, account.class.name, account.id
    else
      Resque.enqueue ImportJob, current_user.id, account.class.name
    end
    flash[:notice] = "#{provider.titlecase} was successfully integrated."
    current_user
    redirect_to '/'
  end
end