ActiveAdmin.register Image do

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

  belongs_to :image_set
  belongs_to :image_group

  navigation_menu :default
  menu false

  permit_params :name, :animated

  filter :name
  filter :animated
  filter :created_at
  filter :updated_at

  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :name
    column :animated
    column :image_frames do |image|
      count = image.image_frames.count
      link_to '%d Image Frame'.pluralize(count) % count, admin_image_set_image_group_image_image_frames_path(image_set, image_group, image)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |image|
    panel 'Image Details' do
      attributes_table_for image do
        row :image_set
        row :image_group
        row :name
        bool_row :animated
      end
    end

    panel 'Image Frames' do
      table_for image.image_frames do
        column :name do |frame|
          link_to frame.frame_name, admin_image_set_image_group_image_image_frame_path(image_set, image_group, image, frame)
        end
        column :created_at
        column :updated_at
      end

      span do
        link_to 'Add Image Frame', new_admin_image_set_image_group_image_image_frame_path(image_set, image_group, image), class: 'button'
      end

      span do
        link_to 'View Image Frames', admin_image_set_image_group_image_image_frames_path(image_set, image_group, image), class: 'button'
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
      f.input :animated

    end

    # f.inputs 'Image Frames' do
    #
    #   f.has_many :image_frames, heading: false, allow_destroy: true do |a|
    #     a.input :name
    #   end
    #
    # end

    f.actions

  end

end
