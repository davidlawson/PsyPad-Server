ActiveAdmin.register GalleryConfiguration do

  menu label: 'Configuration Gallery'

  controller do
    def scoped_collection
      collection = end_of_association_chain
      collection = collection.where(user: [User.first, current_user].uniq) unless current_user.admin?
      collection
    end
  end

  before_create do |gallery_configuration|
    gallery_configuration.user = current_user
  end

  permit_params *Configuration.permitted_params

  filter :user, collection: proc { current_user.admin? ? User.all : [User.first, current_user].uniq }
  filter :name
  filter :title
  filter :image_set
  filter :created_at
  filter :updated_at

  index title: 'Configuration Gallery' do
    selectable_column
    id_column
    column :user
    column :name
    column :title
    column :image_set
    column :created_at
    column :updated_at
    actions defaults: true do |configuration|
      link_to 'Duplicate', duplicate_admin_gallery_configuration_path(configuration), class: 'member_link'
    end
  end

  # /app/views/admin/configurations/_form.html.arb
  form partial: 'admin/configurations/form'

  # /app/views/admin/configurations/_show.html.arb
  show do
    render 'admin/configurations/show'
  end

  # TODO export to participants

  member_action :duplicate, method: :get do
    @gallery_configuration = resource.dup
    render :new, layout: false
  end

  action_item only: :show do
    link_to 'Duplicate Configuration', duplicate_admin_gallery_configuration_path(resource)
  end

end