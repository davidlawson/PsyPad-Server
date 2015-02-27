ActiveAdmin.register Configuration do

  permit_params *Configuration.permitted_params

  belongs_to :participant
  navigation_menu :default
  menu false

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
      (link_to 'Duplicate', duplicate_admin_participant_configuration_path(participant, configuration), class: 'member_link') <<
      (link_to 'Save to Gallery', archive_admin_participant_configuration_path(participant, configuration), class: 'member_link')
    end
  end

  member_action :duplicate, method: :get do
    @configuration = resource.dup
    render :new, layout: false
  end

  action_item only: :show do
    link_to 'Duplicate Configuration', duplicate_admin_participant_configuration_path(participant, configuration)
  end

  member_action :archive, method: [:get, :post] do

    unless request.post?
      @page_title = "Save #{resource.name} to Gallery"
      configurations = GalleryConfiguration.where(user: current_user).all
      render 'archive', locals: { configurations: configurations }
      return
    end

    to_archive = resource
    dest_configuration = params[:configuration]

    unless dest_configuration == 'new'
      to_remove = Configuration.find(dest_configuration)
      to_remove.delete
    end

    new_config = to_archive.dup
    new_config.type = GalleryConfiguration
    new_config.participant = nil
    new_config.user = current_user
    new_config.save

    redirect_to admin_participant_configurations_path(resource.participant), notice: 'Successfully saved configuration to gallery'

  end

  action_item only: :show do
    link_to 'Save to Gallery', action: :archive
  end

  collection_action :import, method: [:get, :post] do

    unless request.post?
      @page_title = 'Import From Gallery'
      configurations = current_user.admin? ? GalleryConfiguration.all : GalleryConfiguration.where(user: [User.first, current_user].uniq)
      render 'import', locals: { configurations: configurations }
      return
    end

    unless params[:configurations]
      redirect_to import_admin_participant_configurations_path(parent), notice: 'No configurations selected to import'
      return
    end

    configurations = params[:configurations].map { |id| GalleryConfiguration.find(id) }

    configurations.each do |configuration|
      new = configuration.dup
      new.user = nil
      new.participant = parent
      new.type = Configuration
      new.save
    end

    redirect_to admin_participant_configurations_path(parent), notice: '%d configurations imported' % configurations.count

  end

  action_item :import, only: :index do
    link_to 'Import From Gallery', action: :import
  end

  # /app/views/admin/configurations/_form.html.arb
  form partial: 'form'

  # /app/views/admin/configurations/_show.html.arb
  show do
    render 'show'
  end

end
