class UsersController < ApplicationController
  def omniauth_failure
    render plain: params['message']
  end
end