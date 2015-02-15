ActiveAdmin.register ImageSet do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :name, image_groups_attributes: [ :id, :name, :_destroy ]

  scope_to :current_user, unless: proc{ current_user.admin? }

  filter :user, if: proc{ current_user.admin? }
  filter :name
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column 'Admin User', :user if current_user.admin?
    column :name
    column :image_groups do |image_set|
      count = image_set.image_groups.count
      link_to '%d Image Group'.pluralize(count) % count, admin_image_set_image_groups_path(image_set)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |image_set|
    panel 'Image Set Details' do
      attributes_table_for image_set do
        if current_user.admin?
          row 'Admin User' do
            image_set.user
          end
        end
        row :name
        row :created_at
        row :updated_at
      end
    end

    panel 'Image Groups' do
      table_for image_set.image_groups do
        column :name do |image_group|
          link_to image_group.name, admin_image_set_image_group_path(image_set, image_group)
        end
        column :created_at
        column :updated_at
      end

      span do
        link_to 'Add Image Group', new_admin_image_set_image_group_path(image_set), class: 'button'
      end

      span do
        link_to 'View Image Groups', admin_image_set_image_groups_path(image_set), class: 'button'
      end
    end

    active_admin_comments
  end

  form do |f|

    f.inputs 'Details' do

      f.input :user if current_user.admin?
      f.input :name

    end

    # f.inputs 'Image Groups' do
    #
    #   f.has_many :image_groups, heading: false, allow_destroy: true do |a|
    #     a.input :name
    #   end
    #
    # end

    f.actions

  end


end
