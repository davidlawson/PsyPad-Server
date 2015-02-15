ActiveAdmin.register ImageFrame do

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
  belongs_to :image

  navigation_menu :default
  menu false

  permit_params :frame

  filter :frame_file_name
  filter :frame_file_size
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column 'ID', :id
    column 'File Name', :frame_file_name
    column 'File Size' do |image_frame|
      '%.2f KB' % (image_frame.frame_file_size / 1024)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |image_frame|
    panel 'Image Frame Details' do
      attributes_table_for image_frame do
        row :frame_file_name, label: 'File Name'
        row 'File Size' do
          '%.2f KB' % (image_frame.frame_file_size / 1024)
        end
        row :frame do
          image_tag image_frame.frame.url
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

      f.input :frame, hint: f.object.frame.present? ? image_tag(f.object.frame.url) : 'No image uploaded'

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
