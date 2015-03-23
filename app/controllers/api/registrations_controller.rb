class API::RegistrationsController < Devise::RegistrationsController

  skip_before_filter :verify_authenticity_token

  respond_to :json

  # TODO this should be in /app/view/api/registrations/create.json.jbuilder
  def create
    user = User.new(sign_up_params)
    if user.save
      render json: { auth_token: user.authentication_token, success: 1 }, status: 201
    else
      warden.custom_failure!
      render json: { error: user.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :affiliation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :affiliation)
  end

end
