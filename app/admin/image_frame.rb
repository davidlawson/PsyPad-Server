ActiveAdmin.register ImageFrame do

  belongs_to :image_set
  belongs_to :image_group
  belongs_to :image

  navigation_menu :default
  menu false

  permit_params :frame

  filter :frame_name
  filter :frame_size
  filter :created_at
  filter :updated_at

  config.sort_order = 'frame_name_asc'

  index do
    selectable_column
    id_column
    column 'File Name', :frame_name
    column 'File Size' do |image_frame|
      image_frame.frame_size.to_s + ' bytes'
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |image_frame|
    panel 'Image Frame Details' do
      attributes_table_for image_frame do
        row :image_set
        row :image_group
        row :image
        row :frame_name, label: 'File Name'
        row 'File Size' do
          image_frame.frame_size.to_s + ' bytes'
        end
        row :frame do
          image_tag image_frame.data_uri
        end
      end
    end

    panel 'Timestamps' do
      attributes_table_for image_frame do
        row :created_at
        row :updated_at
      end
    end

    active_admin_comments
  end

  form do |f|

    f.inputs 'Details' do

      f.input :frame, hint: f.object.frame_path.present? ? image_tag(f.object.data_uri) : 'No image uploaded'

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
