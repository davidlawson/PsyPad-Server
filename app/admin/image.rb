ActiveAdmin.register Image do

  belongs_to :image_set
  belongs_to :image_group

  navigation_menu :default
  menu false

  actions :all, except: [:show, :new]

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
    column 'Preview' do |image|
      image_frame = image.image_frames.first rescue nil
      if image_frame
        image_tag image_frame.thumbnail_data_uri, class: 'frame-preview'
      else
        em 'No preview'
      end
    end
    column :animated
    column :image_frames do |image|
      count = image.image_frames.count
      link_to '%d Image Frame'.pluralize(count) % count, admin_image_set_image_group_image_image_frames_path(image_set, image_group, image)
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|

    f.inputs 'Details' do

      f.input :name
      f.input :animated

      count = image.image_frames.count
      f.input 'Image Frames', as: :output, html: link_to('%d Image Frame'.pluralize(count) % count, admin_image_set_image_group_image_image_frames_path(image_set, image_group, image))

      image_frame = image.image_frames.first rescue nil
      if image_frame
        f.input 'Preview', as: :output, html: image_tag(image_frame.thumbnail_data_uri, class: 'frame-preview')
      end
    end

    f.inputs 'Timestamps' do

      f.input :created_at, as: :output
      f.input :updated_at, as: :output

    end

    f.actions

  end

end
