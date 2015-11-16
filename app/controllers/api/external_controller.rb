class API::ExternalController < ApplicationController

  protect_from_forgery with: :null_session

  #respond_to :json
  skip_before_filter :verify_authenticity_token

  def create_participant

    email = params[:email]
    password = params[:password]
    participant_username = params[:participant_username]

    user = User.find_by_email(email)
    unless user.valid_password?(password)
      render json: { error: 'Invalid email/password' }, status: 403
      return
    end

    unless user.participants.find_by_username(participant_username).nil?
      render json: { error: 'Participant username already taken' }, status: 500
      return
    end

    p = Participant.new
    p.user = user
    p.username = participant_username
    p.save

    render json: { success: true }, status: 200

  end

end