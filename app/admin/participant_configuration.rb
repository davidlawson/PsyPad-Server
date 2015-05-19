ActiveAdmin.register ParticipantConfiguration do

  permit_params *Configuration.permitted_params

  belongs_to :participant

  navigation_menu :default
  menu false

  actions :all, except: [:show]

  filter :name
  filter :title
  filter :enabled
  filter :is_practice
  filter :image_set
  filter :created_at
  filter :updated_at

  # scope :all, default: true
  # scope :non_practice_configurations
  # scope :practice_configurations

  index do
    selectable_column
    id_column
    column :name
    column :title
    column :enabled
    column :is_practice
    column :image_set
    column :position
    column :created_at
    column :updated_at
    actions defaults: true do |configuration|
      (link_to 'Duplicate', duplicate_admin_participant_participant_configuration_path(participant, configuration), class: 'member_link') <<
      (link_to 'Save to Gallery', archive_admin_participant_participant_configuration_path(participant, configuration), class: 'member_link')
    end
  end

  member_action :duplicate, method: :get do
    @participant_configuration = resource.dup
    render :new, layout: false
  end

  action_item only: :show do
    link_to 'Duplicate Configuration', duplicate_admin_participant_participant_configuration_path(participant, participant_configuration)
  end

  member_action :archive, method: [:get, :post] do

    to_overwrite = GalleryConfiguration.where(user: current_user, name: resource.name)

    unless request.post?
      @page_title = "Save #{resource.name} to Gallery"
      render 'admin/configurations/archive', locals: { to_overwrite: to_overwrite }
      return
    end

    to_archive = resource

    if params[:archive] && params[:archive][:overwrite] == '1'
      to_overwrite.delete_all
    end

    new_config = to_archive.dup
    new_config.participant = nil
    new_config = new_config.becomes! GalleryConfiguration
    new_config.user = current_user
    new_config.save

    redirect_to admin_participant_participant_configurations_path(resource.participant), notice: 'Successfully saved configuration to gallery'

  end

  action_item only: :show do
    link_to 'Save to Gallery', action: :archive
  end

  collection_action :import, method: [:get, :post] do

    participant = parent

    unless request.post?
      @page_title = 'Import From Gallery'
      configurations = current_user.admin? ? GalleryConfiguration.all : GalleryConfiguration.where(user: [User.first, current_user].uniq)
      render 'admin/configurations/import', locals: { configurations: configurations, participant: participant }
      return
    end

    unless params[:configurations]
      redirect_to import_admin_participant_configurations_path(participant), notice: 'No configurations selected to import'
      return
    end

    configurations = params[:configurations].map { |id| GalleryConfiguration.find(id) }

    overwrite = params[:import][:overwrite] == '1'

    if overwrite
      configurations.each do |configuration|
        participant.participant_configurations.where(name: configuration.name).delete_all
      end
    end

    configurations.each do |configuration|
      new = configuration.dup
      new.user = nil
      new = new.becomes! ParticipantConfiguration
      new.participant = participant
      new.save
    end

    count = configurations.count
    redirect_to admin_participant_participant_configurations_path(participant), notice: '%d configuration'.pluralize(count) % count + ' imported'

  end

  action_item :import, only: :index do
    link_to 'Import From Gallery', action: :import
  end

  # /app/views/admin/configurations/_form.html.arb
  form partial: 'admin/configurations/form'

end
