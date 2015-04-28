ActiveAdmin.register ImageGroup do

  belongs_to :image_set

  navigation_menu :default
  menu false

  actions :all, except: [:show]

  permit_params :name

  filter :name
  filter :created_at
  filter :updated_at

  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :name
    column 'Preview' do |image_group|
      image_frame = image_group.images.first.image_frames.first
      image_tag image_frame.thumbnail_data_uri, class: 'frame-preview'
    end
    column :images do |image_group|
      count = image_group.images.count
      link_to '%d Image'.pluralize(count) % count, admin_image_set_image_group_images_path(image_set, image_group)
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|

    f.inputs 'Details' do

      f.input :name

      count = image_group.images.count
      f.input 'Images', as: :output, html: link_to('%d Image'.pluralize(count) % count, admin_image_set_image_group_images_path(image_set, image_group))

      image_frame = image_group.images.first.image_frames.first
      f.input 'Preview', as: :output, html: image_tag(image_frame.thumbnail_data_uri, class: 'frame-preview')

    end

    f.inputs 'Timestamps' do

      f.input :created_at, as: :output
      f.input :updated_at, as: :output

    end

    f.actions

  end

end
