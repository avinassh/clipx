require 'resque_web'
=begin
class ResqueController < ResqueWeb::ApplicationController
  before do
    redirect '/users/sign_in' unless request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end
end
=end