#todo https://gist.github.com/dnlserrano/24c975d63e721a02b883

class ApiController < ApplicationController

  acts_as_token_authentication_handler_for User
  protect_from_forgery with: :null_session

  respond_to :json
  skip_before_filter :verify_authenticity_token

  def method

  end

end
