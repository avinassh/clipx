require 'resque/server'

class ResqueController < Resque::Server

  before do
    redirect '/users/sign_in' unless request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

end