ActiveAdmin.register ImageGroup do

  belongs_to :image_set
  navigation_menu :default
  menu false

  permit_params :name

  filter :name
  filter :created_at
  filter :updated_at

  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :name
    column :images do |image_group|
      count = image_group.images.count
      link_to '%d Image'.pluralize(count) % count, admin_image_set_image_group_images_path(image_set, image_group)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |image_group|
    panel 'Image Group Details' do
      attributes_table_for image_group do
        row :image_set
        row :name
      end
    end

    panel 'Images' do
      table_for image_group.images do
        column :name do |image|
          link_to image.name, admin_image_set_image_group_image_path(image_set, image_group, image)
        end
        column :animated
        column :created_at
        column :updated_at
      end

      span do
        link_to 'Add Image', new_admin_image_set_image_group_image_path(image_set, image_group), class: 'button'
      end

      span do
        link_to 'View Images', admin_image_set_image_group_images_path(image_set, image_group), class: 'button'
      end
    end

    panel 'Timestamps' do
      attributes_table_for image_group do
        row :created_at
        row :updated_at
      end
    end

    active_admin_comments
  end

  form do |f|

    f.inputs 'Details' do

      f.input :name

    end

    # f.inputs 'Images' do
    #
    #   f.has_many :images, heading: false, allow_destroy: true do |a|
    #     a.input :name
    #     a.input :animated
    #   end
    #
    # end

    f.actions

  end

end