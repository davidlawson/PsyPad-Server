class API::ParticipantsController < API::BaseController

  skip_before_filter :verify_authenticity_token

  respond_to :json

  def index
    @participants = current_user.participants.where(enabled: true)
  end

  def show
    @participant = current_user.participants.where(enabled: true).find_by_username!(params[:id])
  end

end