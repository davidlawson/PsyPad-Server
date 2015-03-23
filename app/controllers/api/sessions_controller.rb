class API::SessionsController < Devise::SessionsController

  respond_to :json

  skip_before_filter :verify_authenticity_token
  skip_before_filter :verify_signed_out_user

  acts_as_token_authentication_handler_for User, only: [:destroy]

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(scope: :user, store: false)
    if api_user_signed_in?
      current_api_user.authentication_token = nil
      current_api_user.save
    end
  end

  # DELETE /resource/sign_out
  # resets the authentication token, effectively logging out the user
  def destroy
    if api_user_signed_in?
      current_api_user.authentication_token = nil
      current_api_user.save
    else
      render 'failure', status: 401
    end
  end

end