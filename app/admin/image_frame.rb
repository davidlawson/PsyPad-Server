ActiveAdmin.register ImageFrame do

  belongs_to :image_set
  belongs_to :image_group
  belongs_to :image

  navigation_menu :default
  menu false

  actions :all, except: [:show, :new]

  permit_params :frame_name

  filter :frame_name
  filter :frame_size
  filter :created_at
  filter :updated_at

  config.sort_order = 'frame_name_asc'

  index do
    selectable_column
    id_column
    column 'Preview' do |image_frame|
      image_tag image_frame.thumbnail_data_uri, class: 'frame-preview'
    end
    column 'Frame Name', :frame_name
    column 'File Size' do |image_frame|
      image_frame.frame_size.to_s + ' bytes'
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|

    f.inputs 'Details' do

      f.input :frame_name

      f.input 'Image frame', as: :output, html: image_tag(image_frame.data_uri, class: 'frame-preview')
      f.input :frame_size, as: :output, html: image_frame.frame_size.to_s + ' bytes'

    end

    f.inputs 'Timestamps' do

      f.input :created_at, as: :output
      f.input :updated_at, as: :output

    end

    f.actions

  end

end
