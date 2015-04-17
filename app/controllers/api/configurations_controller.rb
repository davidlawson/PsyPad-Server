class API::ConfigurationsController < API::BaseController

  skip_before_filter :verify_authenticity_token

  respond_to :json

  def index
    @configurations = GalleryConfiguration.all
    @configurations = @configurations.where(user: [User.first, current_user].uniq) unless current_user.admin?
  end

  def show
    configurations = GalleryConfiguration.all
    configurations = configurations.where(user: [User.first, current_user].uniq) unless current_user.admin?

    @configuration = configurations.find(params[:id])

    render '_show'
  end

end